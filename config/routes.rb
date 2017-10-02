Rails.application.routes.draw do
	mount ActionCable.server => '/cable'

  resources :jams, only: [:show, :new, :create, :update]
  root to: "jams#new"
end
