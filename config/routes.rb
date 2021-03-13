# frozen_string_literal: true

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :calendars # Creates RESTful routes for the calendar event model.
  resources :calendar_events # Creates RESTful routes for the calendar event model.

  get '/l/:slug', to: 'links#short', as: :short # Sets up the link shortener at /l/
  resources :links # Creates RESTful routes for the link model.

  # Adds routes for user authentication:
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  mount Ahoy::Engine => '/analytics' # Mount ahoy user analytics at a route different from its default.

  resources :pages # Creates RESTful routes for the page model.
  get '/:id' => 'pages#show' # Enables viewing pages without needing to prepend pages/

  get 'dashboard/index' # Adds an informational dashboard (for admin users only).

  root to: 'pages#index' # Sets the root URL, countryroads.tech/
end
