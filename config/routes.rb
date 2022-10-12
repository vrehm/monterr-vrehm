Rails.application.routes.draw do
  resources :communes, only: [:index, :show, :create, :update], defaults: {format: :json}
end
