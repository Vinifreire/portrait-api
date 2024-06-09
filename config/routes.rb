Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get 'stock_ticker/:name', to: 'stock_ticker#show'
end
