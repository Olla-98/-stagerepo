class SessionsController < ApplicationController
  before_action :authenticate_request, only: :destroy

  def create
    user = User.find_by(email: params[:email])
    unless user&.authenticate(params[:password])
      render json: { error: "Ongeldige inloggegevens" }, status: :unauthorized
      return
    end

    user.issue_api_token!
    render json: { token: user.api_token }, status: :ok
  end

  def destroy
    current_user.revoke_api_token!
    head :no_content
  end
end
