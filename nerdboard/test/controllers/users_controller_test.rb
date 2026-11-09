require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @original_organization_id = ENV["SIMPLICATE_ORGANIZATION_ID"]
    ENV["SIMPLICATE_ORGANIZATION_ID"] = "org-42"
  end

  teardown do
    if @original_organization_id.nil?
      ENV.delete("SIMPLICATE_ORGANIZATION_ID")
    else
      ENV["SIMPLICATE_ORGANIZATION_ID"] = @original_organization_id
    end
  end

  test "registration creates an account and returns a usable expiring token" do
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

    saved_user = User.find(user.fetch("id"))
    assert_operator saved_user.api_token_expires_at, :>, Time.current

    get "/me", headers: authorization_headers(token)

    assert_response :ok
    assert_equal "New Customer", response.parsed_body.fetch("name")
  end

  test "registration rejects invalid account data" do
    post "/users", params: {
      user: {
        name: "",
        email: "not-an-email",
        password: "short"
      }
    }, as: :json

    assert_response :unprocessable_entity
    errors = response.parsed_body.fetch("errors").join(" ")
    assert_includes errors, "Name"
    assert_includes errors, "Email"
    assert_includes errors, "Password"
  end

  private

  def authorization_headers(token)
    { "Authorization" => ActionController::HttpAuthentication::Token.encode_credentials(token) }
  end
end
