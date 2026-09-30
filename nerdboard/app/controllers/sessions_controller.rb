class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: { token: user.api_token }, status: :ok
    else
      render json: { error: "Ongeldige inloggegevens" }, status: :unauthorized
    end
  end
end
