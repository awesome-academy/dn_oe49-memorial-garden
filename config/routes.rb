Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    resources :users, except: %i(index destroy) do
      resources :memorials, only: :index
    end
    resources :memorials, only: %i(index show new create) do
      member do
        match "privacy_settings", via: [:get, :patch]
        get "search_unshared_member"
        get "show_biography"
      end
      resources :contributions, only: %i(create edit update destroy)
    end
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :access_privacies, only: %i(create destroy)
  end
end
