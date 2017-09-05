Rails.application.routes.draw do
  resources :jams
  get :fetch_info, to: :fetch_info, controller: :jams
  root to: "jams#index"
end
