Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Change origins to list our front end URLs
    # TODO
    origins '*'

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
