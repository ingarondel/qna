Rails.application.routes.draw do
  devise_for :users
  resources :questions do 
    resources :answers, shallow: true
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
