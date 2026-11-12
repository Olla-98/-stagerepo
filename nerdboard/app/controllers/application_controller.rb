class ApplicationController < ActionController::API
  private

  def authenticate_request
    token = ActionController::HttpAuthentication::Token.token_and_options(request)&.first
    @current_user = User.find_by(api_token: token)
    return if current_user&.api_token_valid?

    @current_user = nil
    render json: { error: "Niet ingelogd" }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
