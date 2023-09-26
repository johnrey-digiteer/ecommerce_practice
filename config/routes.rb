Rails.application.routes.draw do
  get 'wishes/index'
  get 'wishes/show'
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
    resources :order_items, only: [:create, :update]
    resources :reviews
  end

  resources :order_items, except: [:create] do
    collection do
      post 'checkout' # Define a collection route for checkout
    end
    member do
      post 'wishlist' # Define a member route for wishlist
    end
  end

  resources :purchases, only: [:index, :show]
  resources :wishes,  only: [:index, :show, :destroy]

end
