# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Adds user authentication routes.
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }, path: '', path_names: {
    confirmation: 'confirmation',
    password: 'password',
    registration: 'accounts',
    sign_up: 'sign_up',
    sign_in: 'login',
    sign_out: 'logout',
    unlock: 'unlock'
  }
end
