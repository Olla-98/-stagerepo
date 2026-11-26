require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "reports when the Simplicate connection is not configured" do
    user = users(:one)
    user.project_assignments.create!(simplicate_project_id: "project-1")
    names = %w[SIMPLICATE_SUBDOMAIN SIMPLICATE_API_KEY SIMPLICATE_API_SECRET]
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

  test "returns only projects assigned to the authenticated user" do
    first_user = users(:one)
    second_user = users(:two)
    first_user.project_assignments.create!(simplicate_project_id: "project-1")
    second_user.project_assignments.create!(simplicate_project_id: "project-2")
    projects = [
      { "id" => "project-1", "name" => "First project" },
      { "id" => "project-2", "name" => "Second project" }
    ]
    service = Object.new
    service.define_singleton_method(:projects_for) { projects }
    original_new = SimplicateService.method(:new)
    SimplicateService.define_singleton_method(:new) { service }

    get "/projects", headers: { "Authorization" => "Bearer #{first_user.api_token}" }
    assert_response :ok
    assert_equal [ "project-1" ], response.parsed_body.map { |project| project["id"] }

    get "/projects", headers: { "Authorization" => "Bearer #{second_user.api_token}" }
    assert_response :ok
    assert_equal [ "project-2" ], response.parsed_body.map { |project| project["id"] }
  ensure
    SimplicateService.define_singleton_method(:new, original_new) if original_new
  end
end
