# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

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
    resources :answers, concerns: %i[voted commented], shallow: true, only: %i[create update destroy] do
      post 'set_as_top', on: :member
    end
  end

  resources :files, only: %i[destroy]

  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]


  mount ActionCable.server => '/cable'
end
