# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :people, controllers: {
    sessions: 'people/sessions',
    passwords: 'people/passwords'
  }

  root to: 'home#index' #, :as => :authenticated_root

  # Pages
  get 'page/venues', to: 'home#venues'
  get 'page/people', to: 'home#people'
  get 'page/program', to: 'home#program'
  get 'page/surveys', to: 'home#surveys'
  get 'page/reports', to: 'home#reports'

  get 'about/terms_of_use'

  # REST based resources
  resources :people
  resources :programme_items
  resources :programme_assignments
  resources :rooms
  resources :venues
  resources :tag_contexts

  # Surveys and their nested resources
  resources :surveys do
    scope module: 'survey' do
      resources :pages do
        scope module: 'page' do
          resources :questions
        end
      end
      resources :submissions
    end
  end

  # NOTE: if we want submisisons sans surveys fill in the only
  resources :submissions, only: [] do
    scope module: 'submission' do
      resources :responses
    end
  end
end
