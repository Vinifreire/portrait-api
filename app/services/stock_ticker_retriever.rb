# frozen_string_literal: true

class StockTickerRetriever
  class << self
    def call(stock, deps={})
      new(stock, deps).retrieve
    end
  end

  def initialize(stock, deps)
    @stock = stock.upcase
    @redis = deps.fetch(:redis) { RedisAdapter }
    @stock_fetcher = deps.fetch(:stock_fetcher) { StockTickerFetcher }
  end

  def retrieve
    redis.get(stock) || stock_fetcher.call(stock)
  end

  private
  attr_reader :stock, :redis, :stock_fetcher
end
