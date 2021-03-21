Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'home#index' #, :as => :authenticated_root

  # Pages
  get 'page/venues', to: 'home#venues'
  get 'page/people', to: 'home#people'
  get 'page/program', to: 'home#program'
  get 'page/surveys', to: 'home#surveys'
  get 'page/reports', to: 'home#reports'
  # get 'page/program', to: 'home#program'

  # REST based resources
  resources :people
  resources :programme_items
  resources :programme_ssignments
  resources :rooms
  resources :venues
  resources :surveys

end
