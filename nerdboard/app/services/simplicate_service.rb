require "net/http"

class SimplicateService
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

  def organizations
    fake_organizations
  end

  def get_project(project_id)
    project_data = get("/projects/project/#{project_id}", "limit" => PAGE_SIZE, "offset" => 0)
    

    
  end

  # def projects_for(user_id)
  #  project_ids = Project.where(user_id: user_id).pluck(:project_id)
  #  project_ids.each do |project|
  #   get_project(project_id)
  #  end
  # end

  def map_project(project_data)
    budget = project_data["data"]["budget"]["total"]["value_budget"]
    geregistreerde_uren = project_data["data"]["budget"]["total"]["value_spent"]
    resterende_uren = budget - geregistreerde_uren

    project = { 
      id: project_data["data"]["id"], 
      name: project_data["data"]["name"],
      organization_id: project_data["data"]["organization_id"],
      budget:,
      geregistreerde_uren:,
      resterende_uren:
    }
  end

  private

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


  def fake_organizations
    [
      { "id" => 999, "name" => "Testklant BV" },
      { "id" => 111, "name" => "Sila company BV" },
      { "id" => 222, "name" => "Aftertest BV" }
    ]
  end

  def fake_projects
    [
      { "id" => "1", "name" => "Website ontwikkeling en onderhoud", "organization_id" => 999, "budget" => 1000, "geregistreerde_uren" => 10, "resterende_uren" => 20 },
      { "id" => "2", "name" => "Webshop Sima", "organization_id" => 999, "budget" => 5000, "geregistreerde_uren" => 20, "resterende_uren" => 30 },
      { "id" => "3", "name" => "Project 3", "organization_id" => 111, "budget" => 2000, "geregistreerde_uren" => 5, "resterende_uren" => 15 },
      { "id" => "4", "name" => "Project 4", "organization_id" => 222, "budget" => 3000, "geregistreerde_uren" => 8, "resterende_uren" => 12 }

    ]
  end
end
