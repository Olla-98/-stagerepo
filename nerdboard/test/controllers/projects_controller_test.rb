require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "reports when the Simplicate connection is not configured" do
    user = users(:one)
    names = %w[SIMPLICATE_SUBDOMAIN SIMPLICATE_API_KEY SIMPLICATE_API_SECRET SIMPLICATE_ORGANIZATION_ID]
    original = names.to_h { |name| [ name, ENV[name] ] }
    names.each { |name| ENV.delete(name) }

    begin
      get "/projects", headers: { "Authorization" => "Bearer #{user.api_token}" }
    ensure
      original.each { |name, value| value.nil? ? ENV.delete(name) : ENV[name] = value }
    end

    assert_response :service_unavailable
    assert_equal "De Simplicate-koppeling is nog niet volledig ingesteld.", response.parsed_body["error"]
  end

  test "does not return projects without authentication" do
    get "/projects"

    assert_response :unauthorized
  end
end
