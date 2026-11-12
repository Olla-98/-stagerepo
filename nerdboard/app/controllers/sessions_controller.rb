class SessionsController < ApplicationController
  before_action :authenticate_request, only: :destroy

  def create
    email = params[:email].to_s
    user = User.where("LOWER(email) = ?", email.downcase).first
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
