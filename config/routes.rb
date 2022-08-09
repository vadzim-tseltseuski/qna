# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      post 'set_as_top', on: :member
    end
  end

  resources :files, only: %i[destroy]
end
