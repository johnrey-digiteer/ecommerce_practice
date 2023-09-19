Rails.application.routes.draw do
  get 'purchases/index'
  get 'order_items/index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    omniauth: 'users/omniauth',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    unlocks: 'users/unlocks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"

  resources :products do
    resources :order_items, only: [:create]
  end

  resources :order_items, except: [:create] do
    collection do
      post 'checkout' # Define a member route for checkout
    end
  end

  get "/purchases", to: "purchases#index"
end
