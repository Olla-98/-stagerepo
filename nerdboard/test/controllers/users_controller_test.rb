require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "registration creates an account and returns a usable token" do
    post "/users", params: {
      user: {
        name: "New Customer",
        email: "new-customer@example.com",
        password: "secure-password"
      }
    }, as: :json

    assert_response :created
    user = response.parsed_body.fetch("user")
    token = response.parsed_body.fetch("token")
    assert_equal "New Customer", user.fetch("name")
    assert_equal "new-customer@example.com", user.fetch("email")
    assert token.present?

    get "/me", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :ok
    assert_equal "New Customer", response.parsed_body.fetch("name")
  end
end
