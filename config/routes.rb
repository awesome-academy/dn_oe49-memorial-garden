Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    resources :users, except: %i(index destroy) do
      resources :memorials, only: :index do
        get "search", on: :collection, to: "memorials#user_search"
      end
    end
    resources :memorials, only: %i(new create) do
      get "list", on: :collection
      get "search", on: :collection, to: "memorials#public_search"
    end
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
end
