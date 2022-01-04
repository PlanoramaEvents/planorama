require "sidekiq/web"

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :people, path: 'auth',
             controllers: {
               sessions: 'people/sessions',
               passwords: 'people/passwords',
               registrations: 'people/registrations'
             }, defaults: { format: :json }

  root to: 'home#index'

  # TODO: retest with SPA, should be ok
  get '/login/:magic_link', to: 'login#magic_link'

  post '/validator/email', to: 'validator/email#validate' #, controller: 'validator/email'

  # REST based resources
  get 'session/me', to: 'people#me'
  get 'person/me', to: 'people#me'
  get 'people/me', to: 'people#me'
  post 'person/import', to: 'people#import'
  resources :people, path: 'person' do
    get 'person_roles', to: 'person_roles#index'
    get 'email_addresses', to: 'email_addresses#index'
    get 'programme_items', to: 'programme_items#index'
    get 'published_programme_items', to: 'published_programme_items#index'
    get 'mail_histories', to: 'mail_histories#index'
    get 'submissions', to: 'people#submissions'
  end

  resources :person_roles, path: 'person_role', except: [:index]
  resources :email_addresses, path: 'email_address', except: [:index]

  get 'person/:person_id(/survey/:survey_id)/submissions', to: 'people#submissions'
  get 'person/:person_id/mailed_surveys', to: 'people#mailed_surveys'
  get 'person/:person_id/assigned_surveys', to: 'people#assigned_surveys'

  get 'agreement/signed', to: 'agreements#signed'
  get 'agreement/unsigned', to: 'agreements#unsigned'
  put 'agreement/sign/:id', to: 'agreements#sign'
  get 'agreement/latest', to: 'agreements#latest'
  resources :agreements, path: 'agreement'

  # Surveys and their nested resources
  post 'survey/:survey_id/assign_people', to: 'surveys#assign_people'
  post 'survey/:survey_id/unassign_people', to: 'surveys#unassign_people'

  resources :surveys, path: 'survey' do
    resources :pages, controller: 'survey/pages', only: [:index]
    delete 'submission', to: 'survey/submissions#delete_all'
    get 'submissions', to: 'survey/submissions#index'
  end

  resources :pages, path: 'page', controller: 'survey/pages', except: [:index] do
    get 'questions', to: 'survey/page/questions#index'
  end

  resources :questions, controller: 'survey/page/questions', path: 'question', except: [:index] do
    get 'answers', to: 'survey/page/question/answers#index'
  end
  resources :answers, controller: 'survey/page/question/answers', path: 'answer', except: [:index]

  resources :submissions, path: 'submission', controller: 'survey/submissions',  except: [:index] do
    get 'responses', to: 'submission/responses#index'
  end
  resources :responses, path: 'response', controller: 'submission/responses', except: [:index]

  get 'rbac', to: 'rbac#index'

  resources :bios, path: 'bio'
  resources :programme_items, path: 'programme_item'
  resources :published_programme_items, path: 'published_programme_item'
  resources :programme_assignments, path: 'programme_assignment'
  resources :rooms, path: 'room'
  resources :venues, path: 'venue'
  resources :tag_contexts, path: 'tag_context'
  resources :configurations, path: 'configuration'
  resources :parameter_names, path: 'parameter_name'

  resources :mailings, path: 'mailing'

  get 'mailing/preview/:id/:email', to: 'mailings#preview', constraints: { email: /[^\/]+/ }
  get 'mailing/schedule/:id/:email(/:test)', to: 'mailings#schedule', constraints: { email: /[^\/]+/ }
  post 'mailing/:mailing_id/assign_people', to: 'mailings#assign_people'
  post 'mailing/:mailing_id/unassign_people', to: 'mailings#unassign_people'

  # Access to the sidekiq monitoring app...
  authenticate :person, lambda { |p| p.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # force everything back to the SPA home page
  # This has to be at the end otherwise we do not match the resource endpoints
  # as this is a catch all
  match '*path' => redirect('/'), via: :get
end
