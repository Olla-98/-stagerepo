require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "login issues a fresh expiring token" do
    user = users(:one)
    user.update!(name: "Test User", password: "secure-password")
    old_token = user.api_token

    post "/login", params: { email: user.email, password: "secure-password" }

    assert_response :ok
    token = response.parsed_body.fetch("token")
    assert_not_equal old_token, token
    assert_equal token, user.reload.api_token
    assert_operator user.api_token_expires_at, :>, Time.current
  end

  test "login rejects an incorrect password" do
    user = users(:one)
    user.update!(name: "Test User", password: "secure-password")

    post "/login", params: { email: user.email, password: "wrong-password" }

    assert_response :unauthorized
  end

  test "logout revokes the token and the old token cannot authenticate" do
    user = users(:one)
    old_token = user.api_token

    delete "/logout", headers: authorization_headers(old_token)

    assert_response :no_content
    assert_not_equal old_token, user.reload.api_token
    assert_nil user.api_token_expires_at

    get "/me", headers: authorization_headers(old_token)

    assert_response :unauthorized
  end

  test "logout requires a valid token" do
    user = users(:one)
    token = user.api_token

    delete "/logout"

    assert_response :unauthorized
    assert_equal token, user.reload.api_token
  end

  test "expired token cannot authenticate" do
    user = users(:one)
    user.update!(api_token_expires_at: 1.second.ago)

    get "/me", headers: authorization_headers(user.api_token)

    assert_response :unauthorized
  end

  private

  def authorization_headers(token)
    { "Authorization" => ActionController::HttpAuthentication::Token.encode_credentials(token) }
  end
end
