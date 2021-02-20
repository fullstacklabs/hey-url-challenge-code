# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'urls#index'

  namespace 'api' do
    resources :urls, only: %i[index]
  end

  resources :urls, only: %i[index create show], param: :url
  get ':url', to: 'urls#visit', as: :visit
end
