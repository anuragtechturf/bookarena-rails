# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < ApplicationController
  def google
  token = params[:id_token]
  return render json: { error: 'Missing id_token' }, status: :bad_request unless token

  validator = GoogleIDToken::Validator.new
  begin
    payload = validator.check(token, ENV['GOOGLE_CLIENT_ID'])
  rescue GoogleIDToken::ValidationError => e
    return render json: { error: 'Invalid ID token' }, status: :unauthorized
  end

  # Extract info
  email = payload['email']
  name = payload['name']
  google_uid = payload['sub']
  avatar = payload['picture']

  user = User.find_or_initialize_by(google_uid: google_uid)
  user.assign_attributes(
    email: email,
    name: name,
    profile_picture_url: avatar,
    is_email_verified: true
  )
  user.save! if user.changed?

  # ⚠️ ENFORCE PHONE VERIFICATION
  unless user.phone_verified?
    return render json: {
      message: 'Phone verification required',
      user_id: user.id,
      email: user.email,
      phone_verified: false
    }, status: :forbidden
  end

  token = issue_jwt(user)

  render json: {
    token: token,
    user: {
      id: user.id,
      name: user.name,
      email: user.email
    }
  }
end


  private

  def issue_jwt(user)
    payload = {
      sub: user.id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secret_key_base)
  end
end
