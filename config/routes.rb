Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  devise_scope :user do
    post "guest_sign_in", to: "users/sessions#guest_sign_in"
    get "users/account", to: "users/registrations#show", as: :account
  end
  root to: "home#index"
  resources :users, only: [:show, :edit, :update] do
    get :recipes, on: :member
    delete :remove_avatar, on: :collection
  end
  resources :recipes, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :categories, only: [:show] do
    collection do
      get :children
    end
  end
end
