# frozen_string_literal: true

class StockTickerFetcher
  class << self
    def call(stock, deps={})
      new(stock, deps).fetch
    end
  end

  def initialize(stock, deps)
    @stock = stock.upcase
    @http_client = deps.fetch(:http_client) { HttpClientAdapter }
    @ticker_calculate = deps.fetch(:ticker_calculate) { TickerCalculateService }
    @redis = deps.fetch(:redis) { RedisAdapter }
  end

  def fetch
    return response.body if response.status != 200

    return {message: 'no-content'} unless results

    calculated_results = ticker_calculate.call(results)
    
    redis.set(stock, calculated_results)

    calculated_results
  end

  private
  attr_reader :stock, :http_client, :ticker_calculate, :redis

  def response
    @response ||= http_client.get(url, headers)
  end

  def results
    @results ||= JSON.parse(response.body)['results']
  end

  def headers
    @headers ||= {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json; charset=utf-8',
      'Authorization' => "Bearer #{POLYGON_CONFIG[:key]}"
    }
  end

  def url
    @url ||= "#{POLYGON_CONFIG[:url]}/#{stock}/range/1/day/2023-01-01/2023-12-31"
  end
end
