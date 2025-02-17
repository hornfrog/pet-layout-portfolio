Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    post "guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  root to: "home#index"
end
