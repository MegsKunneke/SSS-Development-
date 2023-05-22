Rails.application.routes.draw do
  get 'products/index'
root 'products#index'
resources :products, only: [:index]

end
