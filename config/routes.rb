Rails.application.routes.draw do
  devise_for :users
  root 'gists#index'
  get 'gists/:id' => 'gists#show', as: :gist
end
