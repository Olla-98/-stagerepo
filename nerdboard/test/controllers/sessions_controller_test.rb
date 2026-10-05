require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "logout invalidates the current token" do
    user = users(:one)
    user.update!(password: "secure-password")
    old_token = user.api_token

    delete "/logout", headers: { "Authorization" => "Bearer #{old_token}" }

    assert_response :no_content
    new_token = user.reload.api_token
    assert_not_equal old_token, new_token

    get "/me", headers: { "Authorization" => "Bearer #{old_token}" }

    assert_response :unauthorized

    post "/login", params: { email: user.email, password: "secure-password" }

    assert_response :ok
    assert_equal new_token, response.parsed_body["token"]
  end

  test "logout requires a valid token" do
    user = users(:one)
    token = user.api_token

    delete "/logout"

    assert_response :unauthorized
    assert_equal token, user.reload.api_token
  end
end
