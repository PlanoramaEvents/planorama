require "sidekiq/web"

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :people, path: 'auth',
             controllers: {
               sessions: 'people/sessions',
               passwords: 'people/passwords',
               registrations: 'people/registrations'
             }, defaults: { format: :json }

  root to: 'home#index' #, :as => :authenticated_root
  # force everything back to the SPA home page
  match '*path' => redirect('/'), via: :get

  # TODO: we will need to rework the magic link for SPA routing
  # get '/login/:magic_link', to: 'login#magic_link'

  # Access to the sidekiq monitoring app...
  # authenticate :person, lambda { |p| p.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # Pages - deprecate these
  # get 'page/venues', to: 'home#venues'
  # get 'page/people', to: 'home#people'
  # get 'page/program', to: 'home#program'
  # get 'page/surveys', to: 'home#surveys'
  # get 'page/reports', to: 'home#reports'
  # get 'page/admin', to: 'home#admin'

  # REST based resources
  get 'people/me', to: 'people#me'
  resources :people
  resources :programme_items
  resources :programme_assignments
  resources :rooms
  resources :venues
  resources :tag_contexts
  resources :configurations
  resources :parameter_names

  get 'agreements/signed', to: 'agreements#signed'
  get 'agreements/unsigned', to: 'agreements#unsigned'
  put 'agreements/sign/:id', to: 'agreements#sign'
  get 'agreements/latest', to: 'agreements#latest'
  resources :agreements

  # Surveys and their nested resources
  resources :surveys do
    scope module: 'survey' do
      resources :pages do
        scope module: 'page' do
          resources :questions do
            scope module: 'question' do
              resources :answers
            end
          end
        end
      end
      resources :submissions
      delete 'submissions', to: 'submissions#delete_all'
    end
  end

  # NOTE: if we want submisisons sans surveys fill in the only
  resources :submissions, only: [] do
    scope module: 'submission' do
      resources :responses
    end
  end
end
