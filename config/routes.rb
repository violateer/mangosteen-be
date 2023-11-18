Rails.application.routes.draw do
  get "/users/:id", to: "users#show"
  post "/users/", to: "users#create"
end
