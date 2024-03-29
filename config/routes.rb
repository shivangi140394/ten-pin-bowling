Rails.application.routes.draw do
  resources :games, only: [:create] do
    get 'score', on: :member
  end
end
