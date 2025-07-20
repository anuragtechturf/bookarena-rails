Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # config/routes.rb
  namespace :api do
    namespace :v1 do
      post 'login/google', to: 'auth#google'
      post 'phone_otp/request', to: 'phone_otps#request_otp'
      post 'phone_otp/verify',  to: 'phone_otps#verify_otp'
    end
  end
end
