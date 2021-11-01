Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    resources :users, except: %i(index destroy) do
      resources :memorials, only: :index
    end
    resources :memorials, only: %i(index show new create) do
      match "privacy_settings", on: :member, via: [:get, :patch]
      get "/search_unshared_member", to: "memorials#search_unshared_member"
      resources :contributions, only: :create
    end
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :access_privacies, only: %i(create destroy)
  end
end
