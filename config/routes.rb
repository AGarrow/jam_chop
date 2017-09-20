Rails.application.routes.draw do
	mount ActionCable.server => '/cable'

  resources :jams, only: [:show, :new, :create]
  root to: "jams#new"
end
