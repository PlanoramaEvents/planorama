# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :people, controllers: {
    sessions: 'people/sessions'
  }

  root to: 'home#index' #, :as => :authenticated_root

  # Pages
  get 'page/venues', to: 'home#venues'
  get 'page/people', to: 'home#people'
  get 'page/program', to: 'home#program'
  get 'page/surveys', to: 'home#surveys'
  get 'page/reports', to: 'home#reports'
  # get 'page/program', to: 'home#program'

  get 'about/terms_of_use'

  # REST based resources
  resources :people
  resources :programme_items
  resources :programme_assignments
  resources :rooms
  resources :venues
  resources :tag_contexts

  resources :surveys
  namespace :survey do
    resources :groups
    resources :questions
    resources :responses
  end
end
