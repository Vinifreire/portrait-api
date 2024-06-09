# frozen_string_literal: true
require 'rails_helper'

describe StockTickerFetcher do
  subject(:fetcher) { described_class.call('AAPL', http_client: http_client, redis: redis, ticker_calculate: ticker_calculate) }

  let(:http_client) { class_double('HttpClientAdapter') }
  let(:redis) { class_double('RedisAdapter') }
  let(:ticker_calculate) { class_double('TickerCalculateService') }
  let(:response) { instance_double('Faraday::Response', body: body, status: 200)}
  let(:body) { "{\"ticker\":\"AAPL\",\"queryCount\":250,\"resultsCount\":250,\"adjusted\":true,\"results\":[],\"status\":\"OK\",\"request_id\":\"3437fa0cf2bf78900cbc23ae707b5572\",\"count\":250}" }
  let(:headers) { {"Accept"=>"application/json", "Content-Type"=>"application/json; charset=utf-8", "Authorization"=>"Bearer api-key"} }
  let(:url) { "https://api.polygon.io/v2/aggs/ticker/AAPL/range/1/day/2023-01-01/2023-12-31" }

  before do
    allow(http_client).to receive(:get)
      .with(url, headers)
      .and_return(response)

    allow(ticker_calculate).to receive(:call)
      .with([])
      .and_return('calculated_result')
  end

  context 'when calls fetcher with stocker ticker' do
    it 'fetchs all results in 2023 and save on redis' do
      expect(redis).to receive(:set)
        .with('AAPL', 'calculated_result')

      expect(fetcher).to eq 'calculated_result'
    end
  end

  context 'when calls fetcher with invalid stocker ticker' do
    let(:response) { instance_double('Faraday::Response', body: {}.to_json, status: 200)}

    it { is_expected.to eq({message: 'no-content'}) }
  end

  context 'when calls fetcher with invalid stocker ticker' do
    let(:response) { instance_double('Faraday::Response', body: 'not found', status: 404)}

    it { is_expected.to eq 'not found' }
  end
end
