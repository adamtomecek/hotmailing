Rails.application.routes.draw do
  resources :topics
  resources :messages do
    member do
      post :send_email
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "topics#index"
end
