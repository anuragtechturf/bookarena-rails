require 'twilio-ruby'

class Api::V1::PhoneOtpsController < ApplicationController
  def request_otp
    phone_number = params[:phone_number].to_s.strip

    unless valid_indian_phone_number?(phone_number)
      return render json: { error: 'Invalid Indian phone number with country code' }, status: :unprocessable_entity
    end

    otp_code = generate_otp
    expires_at = 5.minutes.from_now

    PhoneOtp.create!(
      phone_number: phone_number,
      otp_code: otp_code,
      expires_at: expires_at,
      verified: false
    )

    if ENV['SEND_REAL_OTP'] == 'true'
      send_otp_sms(phone_number, otp_code)
    else
      Rails.logger.info "OTP for #{phone_number} is #{otp_code}"
    end

    render json: { message: 'OTP sent successfully' }, status: :ok
  end

  def verify_otp
  phone_number = params[:phone_number].to_s.strip
  otp_code     = params[:otp_code].to_s.strip
  user_id      = params[:user_id]

  otp = PhoneOtp.where(phone_number: phone_number, otp_code: otp_code, verified: false)
                .where('expires_at > ?', Time.current)
                .order(created_at: :desc)
                .first

  if otp
    otp.update!(verified: true)

    if user_id.present?
      user = User.find_by(id: user_id)
      if user
        user.update!(
          phone_number: phone_number,
          phone_verified: true
        )
      end
    else
      user = User.find_by(phone_number: phone_number)
      user.update!(phone_verified: true) if user
    end

    render json: { message: 'Phone number verified successfully' }, status: :ok
  else
    render json: { error: 'Invalid or expired OTP' }, status: :unauthorized
  end
end



  private

  def generate_otp
    SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
  end

  def valid_indian_phone_number?(number)
    number.match?(/\A\+91[6-9]\d{9}\z/)
  end

  def send_otp_sms(phone_number, otp_code)
    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )

    client.api.account.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: phone_number,
      body: "Your OTP code is #{otp_code}"
    )
  end
end
