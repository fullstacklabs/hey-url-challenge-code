# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'urls#index'

  get 'api' => 'urls#api'

  resources :urls, only: %i[index create show], param: :url
  get ':url', to: 'urls#visit', as: :visit
end
