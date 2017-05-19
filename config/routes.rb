Rails.application.routes.draw do
  devise_for :admins
  scope "/admin" do
    resources :admins
  end
  get "/me/:id", to: "customers#edit", as: "edit_customer"
  patch "/me/:id", to: "customers#update"
  put "/me/:id", to: "customers#update"
  get 'url_email/:id', to: 'customers#email', as: 'email_customer'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :customers
  root to: "customers#index"
end
