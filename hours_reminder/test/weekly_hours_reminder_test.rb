require "minitest/autorun"
require "stringio"
require "tmpdir"
require_relative "../lib/weekly_hours_reminder"

class WeeklyHoursReminderTest < Minitest::Test
  class FakeClient
    def employees
      [
        WeeklyHoursReminder::Employee.new(id: "e1", name: "Ada", email: "ada@example.com"),
        WeeklyHoursReminder::Employee.new(id: "e2", name: "Lin", email: "lin@example.com"),
      ]
    end

    def submitted?(employee_id:, date:)
      employee_id == "e1"
    end
  end

  class FakeMailer
    attr_reader :deliveries

    def initialize
      @deliveries = []
    end

    def deliver(**details)
      @deliveries << details
    end
  end

  class FakeHttp
    Response = Struct.new(:code, :body)
    attr_reader :last_request

    def initialize(body)
      @body = body
    end

    def start(*, **)
      yield self
    end

    def request(request)
      @last_request = request
      Response.new("200", @body)
    end
  end

  class FakeSmtp
    attr_reader :message, :from, :recipients, :starttls_enabled

    def enable_starttls_auto
      @starttls_enabled = true
    end

    def start(*)
      yield self
    end

    def send_message(message, from, recipients)
      @message = message
      @from = from
      @recipients = recipients
    end
  end

  def test_previous_week_starts_on_monday
    assert_equal Date.new(2026, 11, 2), WeeklyHoursReminder.previous_week_start(Date.new(2026, 11, 9))
    assert_equal Date.new(2026, 11, 2), WeeklyHoursReminder.previous_week_start(Date.new(2026, 11, 11))
  end

  def test_dry_run_reports_only_employees_without_a_submitted_week
    output = StringIO.new
    runner = WeeklyHoursReminder::Runner.new(
      client: FakeClient.new,
      store: nil,
      mailer: nil,
      send_reminders: false,
      output: output,
    )

    assert_equal 1, runner.run(week_start: Date.new(2026, 11, 2))
    assert_includes output.string, "Lin <lin@example.com>"
    refute_includes output.string, "Ada <ada@example.com>"
  end

  def test_sent_reminders_are_not_sent_twice_for_the_same_employee_and_week
    Dir.mktmpdir do |directory|
      store = WeeklyHoursReminder::DeliveryStore.new(File.join(directory, "reminders.sqlite3"))
      mailer = FakeMailer.new
      runner = WeeklyHoursReminder::Runner.new(
        client: FakeClient.new,
        store: store,
        mailer: mailer,
        send_reminders: true,
        output: StringIO.new,
      )
      week_start = Date.new(2026, 11, 2)

      runner.run(week_start: week_start)
      runner.run(week_start: week_start)

      assert_equal 1, mailer.deliveries.length
      assert_equal "e2", mailer.deliveries.first[:employee].id
    ensure
      store&.close
    end
  end

  def test_simplicate_submission_status_uses_employee_and_week_date
    http = FakeHttp.new('{"data":[{"status":"yet_to_turn_in"}]}')
    client = WeeklyHoursReminder::SimplicateClient.new(
      subdomain: "example",
      api_key: "key",
      api_secret: "secret",
      http: http,
    )

    refute client.submitted?(employee_id: "e1", date: Date.new(2026, 11, 2))
    assert_includes http.last_request.path, "q%5Bemployee_id%5D=e1"
    assert_includes http.last_request.path, "q%5Bstart_date%5D=2026-11-02"
    assert_equal "key", http.last_request["Authentication-Key"]
  end

  def test_unknown_submission_response_fails_closed
    client = WeeklyHoursReminder::SimplicateClient.new(
      subdomain: "example",
      api_key: "key",
      api_secret: "secret",
      http: FakeHttp.new('{"data":{"unknown":"value"}}'),
    )

    assert_raises(WeeklyHoursReminder::SimplicateError) do
      client.submitted?(employee_id: "e1", date: Date.new(2026, 11, 2))
    end
  end

  def test_mailer_sends_reminder_to_employee_using_starttls
    smtp = FakeSmtp.new
    mailer = WeeklyHoursReminder::Mailer.new(
      from: "hours@example.com",
      smtp_address: "smtp.example.com",
      smtp_port: 587,
      username: "user",
      password: "password",
      authentication: "plain",
      starttls: true,
      smtp_factory: ->(_address, _port) { smtp },
    )
    employee = WeeklyHoursReminder::Employee.new(id: "e2", name: "Lin", email: "lin@example.com")

    mailer.deliver(employee: employee, week_start: Date.new(2026, 11, 2), week_end: Date.new(2026, 11, 8))

    assert_equal "hours@example.com", smtp.from
    assert_equal "lin@example.com", smtp.recipients
    assert_includes smtp.message, "Subject: Herinnering urenregistratie: week van 02-11-2026"
    assert_includes smtp.message, "Beste Lin,"
    assert_includes smtp.message, "van 02-11-2026 tot en met 08-11-2026"
    assert_includes smtp.message, "Controleer je urenregistratie en dien de urenweek in via Simplicate."
    assert smtp.starttls_enabled
  end
end
