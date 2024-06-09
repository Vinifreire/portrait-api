class StockTickerController < ActionController::API
  def show
    render json: StockTickerRetriever.call(params['name'])
  end
end
