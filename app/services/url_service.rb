module UrlService
  def self.url_for(path:)
    protocol = Rails.application.config.force_ssl ? "https" : "http"
    host = ENV["HOSTNAME"]
    port = ENV["HOSTPORT"]

    if port
      "#{protocol}://#{host}:#{port}/#{path}"
    else
      "#{protocol}://#{host}/#{path}"
    end
  end
end
