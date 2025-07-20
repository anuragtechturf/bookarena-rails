Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # Allow all origins (for development only)

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: ['Authorization'], # Add custom headers you want to expose
      max_age: 600
  end
end
