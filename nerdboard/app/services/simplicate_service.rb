require "date"
require "json"
require "net/http"
require "uri"

class SimplicateService
  class ConfigurationError < StandardError; end
  class RequestError < StandardError; end

  PAGE_SIZE = 100

  def self.organization_id
    value = ENV["SIMPLICATE_ORGANIZATION_ID"]
    raise ConfigurationError, "SIMPLICATE_ORGANIZATION_ID ontbreekt." if value.blank?

    value.strip
  end

  def initialize(http_client: Net::HTTP)
    @subdomain = ENV["SIMPLICATE_SUBDOMAIN"]
    @api_key = ENV["SIMPLICATE_API_KEY"]
    @api_secret = ENV["SIMPLICATE_API_SECRET"]
    @http_client = http_client

    validate_configuration!
  end

  def projects_for(organization_id)
    organization_id = (organization_id.presence || self.class.organization_id).to_s

    fetch_all("/projects/project", "q[organization.id]" => organization_id)
      .select { |project| organization_id_for(project) == organization_id }
      .map { |project| normalize_project(project) }
  end

  def organizations
    fetch_all("/crm/organization", {}).map do |organization|
      {
        "id" => required_value(organization, "id").to_s,
        "name" => required_value(organization, "name").to_s
      }
    end
  end

  private

  def validate_configuration!
    unless @subdomain&.match?(/\A[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\z/i)
      raise ConfigurationError, "SIMPLICATE_SUBDOMAIN moet het account-subdomein bevatten."
    end

    if @api_key.blank? || @api_secret.blank?
      raise ConfigurationError, "SIMPLICATE_API_KEY en SIMPLICATE_API_SECRET moeten zijn ingesteld."
    end
  end

  def fetch_all(path, filters)
    records = []
    offset = 0

    loop do
      response = request(path, filters.merge(
        "limit" => PAGE_SIZE.to_s,
        "offset" => offset.to_s,
        "metadata" => "count,limit,offset",
      ))
      page = response["data"]
      raise RequestError, "Simplicate gaf geen geldige projectlijst terug." unless page.is_a?(Array)

      records.concat(page)
      offset += page.length
      total = response.dig("metadata", "count")
      break if page.empty? || page.length < PAGE_SIZE || (total && offset >= total.to_i)
    end

    records
  end

  def request(path, query)
    uri = URI::HTTPS.build(
      host: "#{@subdomain}.simplicate.nl",
      path: "/api/v2#{path}",
      query: URI.encode_www_form(query),
    )
    http_request = Net::HTTP::Get.new(uri)
    http_request["Authentication-Key"] = @api_key
    http_request["Authentication-Secret"] = @api_secret
    http_request["Content-Type"] = "application/json"
    http_request["Accept"] = "application/json"

    response = @http_client.start(
      uri.host,
      uri.port,
      use_ssl: true,
      open_timeout: 5,
      read_timeout: 15,
    ) { |http| http.request(http_request) }

    unless response.code.to_i.between?(200, 299)
      raise RequestError, "Simplicate gaf HTTP-status #{response.code} terug."
    end

    JSON.parse(response.body)
  rescue JSON::ParserError
    raise RequestError, "Simplicate gaf een ongeldig JSON-antwoord terug."
  rescue Net::OpenTimeout, Net::ReadTimeout, SocketError, OpenSSL::SSL::SSLError, IOError, SystemCallError => error
    raise RequestError, "Simplicate is niet bereikbaar (#{error.class})."
  end

  def organization_id_for(project)
    value = first_value(project, "organization.id", "organization_id")
    value&.to_s
  end

  def normalize_project(project)
    budget = numeric_value(project, "budget_hours_amount_budget", "budget.hours.amount.budget")
    recorded = numeric_value(project, "budget_hours_amount_spent", "budget.hours.amount.spent")
    status_label = first_value(project, "project_status_label", "project_status.label", "status")

    {
      "id" => required_value(project, "id").to_s,
      "name" => required_value(project, "name").to_s,
      "description" => first_value(project, "note", "description").to_s,
      "status" => normalize_status(status_label),
      "budget" => budget,
      "recorded" => recorded,
      "updatedAt" => format_date(first_value(project, "updated_at", "modified", "created_at")),
      "phases" => []
    }
  end

  def first_value(record, *paths)
    paths.each do |path|
      value = path.split(".").reduce(record) do |current, key|
        current.is_a?(Hash) ? (current[key] || current[key.to_sym]) : nil
      end
      return value unless value.nil?
    end

    nil
  end

  def required_value(record, key)
    value = first_value(record, key)
    raise RequestError, "Simplicate-project mist het verplichte veld #{key}." if value.blank?

    value
  end

  def numeric_value(record, *paths)
    value = first_value(record, *paths)
    return 0 if value.nil? || value == ""

    Float(value)
  rescue ArgumentError, TypeError
    raise RequestError, "Simplicate gaf een ongeldig urenbudget terug."
  end

  def normalize_status(value)
    label = value.to_s.downcase
    return "Afgerond" if label.match?(/complete|completed|closed|finished|afgerond/)
    return "On hold" if label.match?(/hold|paused|on-hold/)

    "Actief"
  end

  def format_date(value)
    return "" if value.blank?

    Date.parse(value.to_s).strftime("%d-%m-%Y")
  rescue Date::Error
    value.to_s
  end
end
