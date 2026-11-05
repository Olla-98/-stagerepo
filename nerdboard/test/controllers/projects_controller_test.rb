require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "returns only projects belonging to the authenticated user's organization" do
    user = users(:one)
    user.update_column(:simplicate_organization_id, 999)

    get "/projects", headers: { "Authorization" => "Bearer #{user.api_token}" }

    assert_response :ok
    assert_equal [
      {
        "id" => "1",
        "name" => "Website ontwikkeling en onderhoud",
        "budget" => 1000,
        "recorded" => 10,
        "remaining" => 990
      },
      {
        "id" => "2",
        "name" => "Webshop Sima",
        "budget" => 5000,
        "recorded" => 20,
        "remaining" => 4980
      }
    ], response.parsed_body
  end

  test "projects require authentication" do
    get "/projects"

    assert_response :unauthorized
  end
end
