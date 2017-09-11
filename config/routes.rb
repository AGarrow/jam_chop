Rails.application.routes.draw do
	mount ActionCable.server => '/cable'

  resources :jams
  root to: "jams#new"
end
