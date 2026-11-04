class UsersController < ApplicationController
  before_action :authenticate_request, only: [:me]

  def create
    user = User.new(user_params)

    if user.save
      render json: {
        token: user.api_token,
        user: { id: user.id, name: user.name, email: user.email }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def me
    render json: {
      id: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      simplicate_organization_id: @current_user.simplicate_organization_id
    }, status: :ok
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
