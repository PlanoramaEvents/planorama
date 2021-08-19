Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Change origins to lisr our front end URLs
    origins '*'

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
