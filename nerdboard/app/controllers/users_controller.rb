class UsersController < ApplicationController
  before_action :authenticate_request, only: [ :me ]

  def create
    user = User.new(user_params)
    user.simplicate_organization_id = SimplicateService.organization_id

    if user.save
      render json: {
        token: user.api_token,
        user: { id: user.id, name: user.name, email: user.email }
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages,
        error_codes: user.errors.map { |error| "#{error.attribute}_#{error.type}" }
      }, status: :unprocessable_entity
    end
  rescue SimplicateService::ConfigurationError => error
    Rails.logger.error("Simplicate configuration error: #{error.message}")
    render json: { error: "De projectorganisatie is momenteel niet beschikbaar." }, status: :service_unavailable
  end

  def me
    render json: {
      id: current_user.id,
      name: current_user.name,
      email: current_user.email
    }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
