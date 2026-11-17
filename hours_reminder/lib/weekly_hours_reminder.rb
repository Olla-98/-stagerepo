require "date"
require "fileutils"
require "json"
require "net/http"
require "net/smtp"
require "openssl"
require "sqlite3"
require "time"
require "uri"

module WeeklyHoursReminder
  class ConfigurationError < StandardError; end
  class SimplicateError < StandardError; end

  Employee = Struct.new(:id, :name, :email, keyword_init: true)

  class SimplicateClient
    PAGE_SIZE = 100
    MIN_REQUEST_INTERVAL = 1.05

    def initialize(subdomain:, api_key:, api_secret:, http: Net::HTTP, clock: -> { Process.clock_gettime(Process::CLOCK_MONOTONIC) }, sleeper: ->(seconds) { sleep(seconds) })
      @subdomain = subdomain
      @api_key = api_key
      @api_secret = api_secret
      @http = http
      @clock = clock
      @sleeper = sleeper
      @last_request_at = nil

      raise ConfigurationError, "Simplicate API-instellingen ontbreken." if [subdomain, api_key, api_secret].any?(&:empty?)
    end

    def employees
      skipped_records = 0
      employees = fetch_all("/hrm/employee").filter_map do |record|
        unless record.is_a?(Hash)
          skipped_records += 1
          next
        end

        person = record["person"].is_a?(Hash) ? record["person"] : {}
        id = record["id"]
        email = record["work_email"] || record["email"] || person["work_email"] || person["email"]
        name = record["name"] || person["full_name"] || [record["first_name"], record["last_name"]].compact.join(" ")
        unless !id.to_s.empty? && email.to_s.match?(/\A[^\s@\r\n]+@[^\s@\r\n]+\z/)
          skipped_records += 1
          next
        end

        Employee.new(id: id.to_s, name: name.to_s, email: email.to_s)
      end

      warn "Simplicate: #{skipped_records} medewerkerrecord(s) overgeslagen omdat een geldig ID of e-mailadres ontbreekt." if skipped_records.positive?
      employees
    end

    def submitted?(employee_id:, date:)
      response = get(
        "/hours/submission",
        "q[start_date]" => date.iso8601,
        "q[end_date]" => (date + 6).iso8601,
        "q[employee_id]" => employee_id,
      )
      data = response["data"]
      unless data.is_a?(Array) && data.any?
        raise SimplicateError, "Simplicate gaf geen indienstatussen voor de urenweek terug."
      end

      statuses = data.map { |entry| entry.is_a?(Hash) ? status_value(entry["status"]) : nil }
      if statuses.any?(&:nil?)
        raise SimplicateError, "Onbekende status in het Simplicate-antwoord voor de urenweek."
      end

      statuses.all? { |status| status == :submitted || status == :no_hours }
    end

    private

    def status_value(value)
      case value.to_s.downcase
      when "submitted"
        :submitted
      when "no_hours", "no_registrations"
        :no_hours
      when "yet_to_turn_in"
        :yet_to_turn_in
      end
    end

    def fetch_all(path)
      records = []
      offset = 0

      loop do
        response = get(path, "limit" => PAGE_SIZE, "offset" => offset)
        page = response["data"]
        raise SimplicateError, "Simplicate gaf geen geldige medewerkerslijst terug." unless page.is_a?(Array)

        records.concat(page)
        break if page.length < PAGE_SIZE

        offset += page.length
      end

      records
    end

    def get(path, query)
      wait_for_rate_limit
      uri = URI::HTTPS.build(
        host: "#{@subdomain}.simplicate.nl",
        path: "/api/v2#{path}",
        query: URI.encode_www_form(query),
      )
      request = Net::HTTP::Get.new(uri)
      request["Authentication-Key"] = @api_key
      request["Authentication-Secret"] = @api_secret
      request["Content-Type"] = "application/json"
      request["Accept"] = "application/json"

      response = @http.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 15) do |client|
        client.request(request)
      end
      @last_request_at = @clock.call
      raise SimplicateError, "Simplicate gaf HTTP-status #{response.code} terug." unless response.code.to_i.between?(200, 299)

      JSON.parse(response.body)
    rescue JSON::ParserError
      raise SimplicateError, "Simplicate gaf een ongeldig JSON-antwoord terug."
    rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, OpenSSL::SSL::SSLError, IOError, SystemCallError => error
      raise SimplicateError, "Simplicate is niet bereikbaar (#{error.class})."
    end

    def wait_for_rate_limit
      return unless @last_request_at

      elapsed = @clock.call - @last_request_at
      @sleeper.call(MIN_REQUEST_INTERVAL - elapsed) if elapsed < MIN_REQUEST_INTERVAL
    end
  end

  class DeliveryStore
    def initialize(path)
      FileUtils.mkdir_p(File.dirname(path))
      @database = SQLite3::Database.new(path)
      @database.execute(<<~SQL)
        CREATE TABLE IF NOT EXISTS reminder_deliveries (
          employee_id TEXT NOT NULL,
          week_start TEXT NOT NULL,
          status TEXT NOT NULL,
          claimed_at TEXT NOT NULL,
          sent_at TEXT,
          PRIMARY KEY (employee_id, week_start)
        )
      SQL
    end

    def claim(employee_id:, week_start:, now: Time.now.utc, lease_seconds: 3600)
      stale_at = (now - lease_seconds).iso8601
      @database.transaction(:immediate)
      @database.execute(
        <<~SQL,
          INSERT INTO reminder_deliveries (employee_id, week_start, status, claimed_at)
          VALUES (?, ?, 'pending', ?)
          ON CONFLICT(employee_id, week_start) DO NOTHING
        SQL
        [employee_id, week_start, now.iso8601],
      )

      if @database.changes == 1
        @database.commit
        return true
      end

      row = @database.get_first_row(
        "SELECT status, claimed_at FROM reminder_deliveries WHERE employee_id = ? AND week_start = ?",
        [employee_id, week_start],
      )
      if row && row[0] == "pending" && row[1] < stale_at
        @database.execute(
          "UPDATE reminder_deliveries SET claimed_at = ? WHERE employee_id = ? AND week_start = ? AND status = 'pending'",
          [now.iso8601, employee_id, week_start],
        )
        @database.commit
        return @database.changes == 1
      end

      @database.commit
      false
    rescue StandardError
      @database.rollback if @database.transaction_active?
      raise
    end

    def mark_sent(employee_id:, week_start:, now: Time.now.utc)
      @database.execute(
        "UPDATE reminder_deliveries SET status = 'sent', sent_at = ? WHERE employee_id = ? AND week_start = ? AND status = 'pending'",
        [now.iso8601, employee_id, week_start],
      )
      raise "Reminder delivery claim was lost before marking it sent." unless @database.changes == 1
    end

    def release(employee_id:, week_start:)
      @database.execute(
        "DELETE FROM reminder_deliveries WHERE employee_id = ? AND week_start = ? AND status = 'pending'",
        [employee_id, week_start],
      )
    end

    def close
      @database.close
    end
  end

  class Mailer
    def initialize(from:, smtp_address:, smtp_port:, username:, password:, authentication:, starttls:, smtp_factory: nil)
      @from = from
      @smtp_address = smtp_address
      @smtp_port = smtp_port
      @username = username
      @password = password
      @authentication = authentication
      @starttls = starttls
      @smtp_factory = smtp_factory || ->(address, port) { Net::SMTP.new(address, port) }
      if [from, smtp_address].any?(&:empty?)
        raise ConfigurationError, "REMINDER_FROM en SMTP_ADDRESS moeten zijn ingesteld om e-mail te versturen."
      end
    end

    def deliver(employee:, week_start:, week_end:)
      subject = "Herinnering urenregistratie: week van #{week_start.strftime('%d-%m-%Y')}"
      body = <<~TEXT
        Beste #{employee.name},

        Volgens de registratie in Simplicate is je urenweek van #{week_start.strftime('%d-%m-%Y')} tot en met #{week_end.strftime('%d-%m-%Y')} nog niet ingediend.
        Controleer je urenregistratie en dien de urenweek in via Simplicate.

        Alvast bedankt.
      TEXT
      message = [
        "From: #{@from}",
        "To: #{employee.email}",
        "Subject: #{subject}",
        "Date: #{Time.now.rfc2822}",
        "MIME-Version: 1.0",
        "Content-Type: text/plain; charset=UTF-8",
        "",
        body,
      ].join("\r\n")

      smtp = @smtp_factory.call(@smtp_address, @smtp_port)
      smtp.enable_starttls_auto if @starttls
      username = @username.empty? ? nil : @username
      password = @password.empty? ? nil : @password
      smtp.start("localhost", username, password, @authentication.to_sym) do |connection|
        connection.send_message(message, @from, employee.email)
      end
    end
  end

  class Runner
    def initialize(client:, store:, mailer:, send_reminders:, employee_ids: [], output: $stdout)
      @client = client
      @store = store
      @mailer = mailer
      @send_reminders = send_reminders
      @employee_ids = employee_ids.map(&:to_s)
      @output = output
    end

    def run(week_start:)
      week_end = week_start + 6
      employees = @client.employees
      if @employee_ids.any?
        found_ids = employees.map(&:id)
        missing_ids = @employee_ids - found_ids
        raise ConfigurationError, "Onbekende Simplicate-medewerker-ID(s): #{missing_ids.join(', ')}." if missing_ids.any?

        employees.select! { |employee| @employee_ids.include?(employee.id) }
      end
      late = employees.reject { |employee| @client.submitted?(employee_id: employee.id, date: week_start) }
      @output.puts("Week #{week_start}–#{week_end}: #{late.length} medewerker(s) missen de indiening.")

      late.each do |employee|
        unless @send_reminders
          @output.puts("DRY RUN: #{employee.name} <#{employee.email}>")
          next
        end

        next unless @store.claim(employee_id: employee.id, week_start: week_start.iso8601)

        begin
          @mailer.deliver(employee: employee, week_start: week_start, week_end: week_end)
          @store.mark_sent(employee_id: employee.id, week_start: week_start.iso8601)
          @output.puts("Herinnering verstuurd naar medewerker #{employee.id}.")
        rescue StandardError
          @store.release(employee_id: employee.id, week_start: week_start.iso8601)
          raise
        end
      end

      late.length
    end
  end

  module_function

  def previous_week_start(today = Date.today)
    this_monday = today - (today.cwday - 1)
    this_monday - 7
  end
end
