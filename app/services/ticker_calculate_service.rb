# frozen_string_literal: true

class TickerCalculateService
  class << self
    def call(results, deps={})
      new(results, deps).hash_to_json
    end
  end

  def initialize(results, deps)
    @results = results
    @highest_price, @lowest_price = [Float::MIN, Float::MAX]
    @highest_volume, @lowest_volume, @avarege_volume = [Float::MIN, Float::MAX, 0]

    calculate
  end

  def hash_to_json
    {
      'price': [highest_price, lowest_price, (highest_price + lowest_price)/2],
      'volume': [highest_volume, lowest_volume, avarege_volume/results.count]
    }.to_json
  end

  private
  attr_reader :results
  attr_reader :highest_price, :lowest_price
  attr_reader :highest_volume, :lowest_volume, :avarege_volume

  def calculate
    results.each do |result|
      @highest_price = [highest_price, result['h'], result['l']].max
      @lowest_price = [lowest_price, result['h'], result['l']].min
      @highest_volume = [highest_volume, result['v']].max
      @lowest_volume = [lowest_volume, result['v']].min
      @avarege_volume += result['vw']
    end
  end
end
