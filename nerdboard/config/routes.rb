Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users", to: "users#create"
  post "/login", to: "sessions#create"
end

