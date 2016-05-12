Rails.application.routes.draw do
  get 'gists/:id' => 'gists#show', as: :gist
end
