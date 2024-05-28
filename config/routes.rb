Rails.application.routes.draw do
  devise_for :users, controllers: { omiauth_callbacks: 'oauth_callbacks'}
  resources :questions do 
    resources :answers, shallow: true
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
