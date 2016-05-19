Rails.application.routes.draw do
  root 'welcome#index'
  
  get 'gists/new' => 'gists#new'
  get 'gists/:id' => 'gists#show', as: :gist
end
