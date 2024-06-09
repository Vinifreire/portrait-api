class HttpClientAdapter
  class ConnectionFailed < StandardError; end

  class << self
    def get(url, headers = nil)
      new.send(:request, :get, url, headers)
    end
  end

  private
  def request(verb, url, headers)
    client.send(verb, url, {}, headers)
  rescue Faraday::ConnectionFailed => e
    raise ConnectionFailed, e.message
  end

  def client
    @client ||= Faraday.new do |faraday|
      faraday.request :url_encoded
    end
  end
end
