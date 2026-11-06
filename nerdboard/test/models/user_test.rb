require "test_helper"

class UserTest < ActiveSupport::TestCase
  def valid_attributes
    {
      name: "Test User",
      email: "new-user@example.com",
      password: "secure-password"
    }
  end

  test "valid user receives an API token with an expiry" do
    user = User.create!(valid_attributes)

    assert user.api_token.present?
    assert_operator user.api_token_expires_at, :>, Time.current
    assert_operator user.api_token_expires_at, :<=, 1.hour.from_now
  end

  test "requires a name and a valid email address" do
    user = User.new(valid_attributes.merge(name: "", email: "not-an-email"))

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
    assert_includes user.errors[:email], "is invalid"
  end

  test "requires a unique email address regardless of case" do
    user = User.new(valid_attributes.merge(email: "ONE@example.com"))

    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "requires a password with at least eight characters" do
    user = User.new(valid_attributes.merge(password: "short"))

    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end

  test "revoking a token clears its expiry and replaces its value" do
    user = users(:one)
    old_token = user.api_token

    user.revoke_api_token!

    assert_not_equal old_token, user.api_token
    assert_nil user.api_token_expires_at
    assert_not user.api_token_valid?
  end
end
