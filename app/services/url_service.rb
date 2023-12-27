module UrlService
  def self.url_for(path:)
    protocol = Rails.application.config.force_ssl ? "https" : "http"
    host = ENV["HOSTNAME"]
    port = ENV["HOSTPORT"]

    # Remove any slash from the start of the path if there happens to be one
    # as we add one when building the URL with the protocol and host
    if path.start_with?("/")
      path = path[1..-1]
    end

    if port
      "#{protocol}://#{host}:#{port}/#{path}"
    else
      "#{protocol}://#{host}/#{path}"
    end
  end
end
