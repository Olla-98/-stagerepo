require "test_helper"

class SimplicateServiceTest < ActiveSupport::TestCase
  Response = Struct.new(:code, :body)

  test "requests and normalizes projects for the configured organization" do
    response = Response.new("200", {
      data: [
        {
          id: "project-1",
          name: "Website",
          organization: { id: "org-42" },
          project_status: { label: "Active" },
          budget_hours_amount_budget: "80",
          budget_hours_amount_spent: "24.5",
          updated_at: "2026-10-12T10:00:00Z",
          note: "Website updates"
        },
        { id: "project-2", name: "Other", organization_id: "org-99" }
      ],
      metadata: { count: 2 }
    }.to_json)
    client, request = http_client(response)

    with_configuration do
      projects = SimplicateService.new(http_client: client).projects_for(nil)

      assert_equal 1, projects.length
      assert_equal(
        {
          "id" => "project-1",
          "name" => "Website",
          "description" => "Website updates",
          "status" => "Actief",
          "budget" => 80.0,
          "recorded" => 24.5,
          "updatedAt" => "12-10-2026",
          "phases" => []
        },
        projects.first,
      )
      http_request = request.call
      assert_equal "private-key", http_request["Authentication-Key"]
      assert_equal "private-secret", http_request["Authentication-Secret"]
      assert_equal "application/json", http_request["Content-Type"]
      assert_equal "org-42", URI.decode_www_form(http_request.uri.query).to_h["q[organization.id]"]
    end
  end

  test "raises a clear error when the API rejects the credentials" do
    client, = http_client(Response.new("401", "{}"))

    with_configuration do
      error = assert_raises(SimplicateService::RequestError) do
        SimplicateService.new(http_client: client).projects_for("org-42")
      end

      assert_equal "Simplicate gaf HTTP-status 401 terug.", error.message
    end
  end

  test "lists organizations with their Simplicate IDs" do
    response = Response.new("200", {
      data: [ { id: "org-42", name: "Klant BV" } ],
      metadata: { count: 1 }
    }.to_json)
    client, request = http_client(response)

    with_configuration do
      organizations = SimplicateService.new(http_client: client).organizations

      assert_equal [ { "id" => "org-42", "name" => "Klant BV" } ], organizations
      assert_equal "nerds.simplicate.nl", request.call.uri.host
      assert_equal "/api/v2/crm/organization", request.call.uri.path
    end
  end

  private

  def http_client(response)
    request = nil
    connection = Object.new
    connection.define_singleton_method(:request) do |http_request|
      request = http_request
      response
    end
    client = Object.new
    client.define_singleton_method(:start) do |*_args, **_options, &block|
      block.call(connection)
    end
    [ client, -> { request } ]
  end

  def with_configuration
    original = %w[SIMPLICATE_SUBDOMAIN SIMPLICATE_API_KEY SIMPLICATE_API_SECRET SIMPLICATE_ORGANIZATION_ID]
      .to_h { |key| [ key, ENV[key] ] }
    ENV["SIMPLICATE_SUBDOMAIN"] = "nerds"
    ENV["SIMPLICATE_API_KEY"] = "private-key"
    ENV["SIMPLICATE_API_SECRET"] = "private-secret"
    ENV["SIMPLICATE_ORGANIZATION_ID"] = "org-42"
    yield
  ensure
    original.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
  end
end
