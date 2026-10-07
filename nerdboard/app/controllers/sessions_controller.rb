class SessionsController < ApplicationController
  before_action :authenticate_request, only: :destroy

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password]) 
      render json: { token: user.api_token }, status: :ok
    else
      render json: { error: "Ongeldige inloggegevens" }, status: :unauthorized
    end
  end

  def destroy
    @current_user.update!(api_token: SecureRandom.hex(32))
    head :no_content
  end
end
