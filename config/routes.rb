Rails.application.routes.draw do
  root 'gists#index'
  get 'gists/:id' => 'gists#show', as: :gist
end
