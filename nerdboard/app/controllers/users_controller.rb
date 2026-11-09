class UsersController < ApplicationController
  before_action :authenticate_request, only: [:me]

  def create
    user = User.new(user_params)
    user.simplicate_organization_id = SimplicateService.organization_id

    if user.save
      render json: { id: user.id, email: user.email }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue SimplicateService::ConfigurationError => error
    Rails.logger.error("Simplicate configuration error: #{error.message}")
    render json: { error: "De Simplicate-organisatie is nog niet ingesteld." }, status: :service_unavailable
  end

  def me
    render json: { id: @current_user.id, email: @current_user.email, simplicate_organization_id: @current_user.simplicate_organization_id }, status: :ok
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
