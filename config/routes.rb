Rails.application.routes.draw do
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :pdf

  resources :tests, only: [:create]

  namespace :api do
    namespace :v1 do
      resources :pdf, only: [:create, :show]
    end
  end
end
