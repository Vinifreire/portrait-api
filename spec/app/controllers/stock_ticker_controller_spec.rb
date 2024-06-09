require 'rails_helper'

RSpec.describe StockTickerController, type: :controller do
  describe "GET #show" do
    let(:ticker_name) { "AAPL" }
    let(:stock_ticker) { double("StockTicker") }

    before do
      allow(StockTickerRetriever).to receive(:call).with(ticker_name).and_return(stock_ticker)
      get :show, params: { name: ticker_name }
    end

    it "calls StockTickerRetriever with the correct ticker name" do
      expect(StockTickerRetriever).to have_received(:call).with(ticker_name)
    end

    it "returns a success response" do
      expect(response).to be_successful
    end
  end
end
