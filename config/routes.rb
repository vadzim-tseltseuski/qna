# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
    mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

  get '/email', to: 'users#email'
  post '/set_email', to: 'users#set_email'

  concern :voted do
    member do
      post :vote_plus
      post :vote_minus
      delete :delete_vote
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  resources :questions, concerns: %i[voted commented] do
    resources :subscriptions, shallow: true, only: %i[create destroy]
    resources :answers, concerns: %i[voted commented], shallow: true, only: %i[create update destroy] do
      post 'set_as_top', on: :member
    end
  end

  resources :files, only: %i[destroy]

  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :others, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        get :answers, on: :member
        resources :answers, shallow: true, only: %i[show create update destroy]
      end
    end
  end


  mount ActionCable.server => '/cable'
end
