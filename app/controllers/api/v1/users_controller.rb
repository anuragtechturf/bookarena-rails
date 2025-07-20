class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def complete_profile
    user = current_user

    unless user.phone_verified?
      return render json: { error: 'Phone number must be verified before completing profile' }, status: :forbidden
    end

    if user.update(user_params)
      render json: { message: 'Profile completed successfully' }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :dob, :gender)
  end
end
