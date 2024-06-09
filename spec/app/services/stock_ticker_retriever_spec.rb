require 'rails_helper'

describe StockTickerRetriever do
  subject(:retriever) { described_class.call('AAPL', redis: redis, stock_fetcher: stock_fetcher) }

  let(:http_client) { class_double('HttpClientAdapter') }
  let(:redis) { class_double('RedisAdapter') }
  let(:stock_fetcher) { class_double('StockTickerFetcher') }

  before do
    allow(redis).to receive(:get)
      .with('AAPL')
      .and_return(cache)
  end

  context 'when redis find a key' do
    let(:cache) { 'cached-content' }

    it { is_expected.to eq 'cached-content' }
  end

  context 'when calls fetcher' do
    let(:cache) { nil }

    it 'fetchs all results in 2023 and save on redis' do
      expect(stock_fetcher).to receive(:call)
        .with('AAPL')

      retriever
    end
  end
end
