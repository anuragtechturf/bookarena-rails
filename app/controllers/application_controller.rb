# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  def authenticate_user!
    header = request.headers['Authorization']
    token = header&.split(' ')&.last

    if token
      begin
        payload = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256').first
        @current_user = User.find(payload['sub'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Missing token' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
