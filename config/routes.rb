Rails.application.routes.draw do
  resources :games, only: [:create] do
    resources :frames, only: [] do
      post :roll, on: :collection
    end
    get 'score', on: :member
  end
end
