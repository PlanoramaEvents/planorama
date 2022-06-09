require "sidekiq/web"

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  devise_for :people, path: 'auth',
             controllers: {
               sessions: 'people/sessions',
               passwords: 'people/passwords',
               registrations: 'people/registrations',
               unlocks: 'people/unlocks'
               # UnlocksController
             }, defaults: { format: :json }

  root to: 'home#index'
  # get '/home', to: 'home#index'

  get '/login/:magic_link', to: 'login#magic_link'

  post '/validator/email', to: 'validator/email#validate'

  get '/settings', to: 'settings#index'

  # REST based resources
  get 'person/session/me', to: 'people#me'
  get 'person/me', to: 'people#me'
  get 'people/me', to: 'people#me'
  post 'person/import', to: 'people#import'
  post 'person/update_all', to: 'people#update_all'
  resources :people, path: 'person' do
    get 'convention_roles', to: 'convention_roles#index'
    get 'email_addresses', to: 'email_addresses#index'
    get 'sessions', to: 'sessions#index'
    get 'published_sessions', to: 'published_sessions#index'
    get 'mail_histories', to: 'mail_histories#index'
    get 'submissions', to: 'people#submissions'
    resources :availabilities, path: 'availability', only: [:index]
    patch 'availability', to: 'availabilities#replace'
    resources :person_exclusions, path: 'person_exclusion', only: [:index]
    patch 'person_exclusion', to: 'person_exclusions#replace'
    resources :session_limits, path: 'session_limit', only: [:index]
    # patch 'session_limit', to: 'session_limits#replace'
  end
  get 'person/:person_id(/survey/:survey_id)/submissions', to: 'people#submissions'
  get 'person/:person_id/mailed_surveys', to: 'people#mailed_surveys'
  get 'person/:person_id/assigned_surveys', to: 'people#assigned_surveys'

  get 'report/participant_selections', to: 'reports#participant_selections'
  get 'report/session_selections', to: 'reports#session_selections'
  get 'report/participant_availabilities', to: 'reports#participant_availabilities'
  get 'report/assigned_sessions_by_participant', to: 'reports#assigned_sessions_by_participant'
  get 'report/sessions_with_participants', to: 'reports#sessions_with_participants'
  get 'report/people_and_submissions', to: 'reports#people_and_submissions'

  resources :availabilities, path: 'availability', except: [:index]
  resources :person_exclusions, path: 'person_exclusion', except: [:index]
  resources :session_limits, path: 'session_limit', except: [:index]

  resources :convention_roles, path: 'convention_role', except: [:index]
  resources :email_addresses, path: 'email_address', except: [:index]

  get 'agreement/signed', to: 'agreements#signed'
  get 'agreement/unsigned', to: 'agreements#unsigned'
  put 'agreement/sign/:id', to: 'agreements#sign'
  get 'agreement/latest', to: 'agreements#latest'
  resources :agreements, path: 'agreement'

  get 'session_conflict', to: 'conflicts/session_conflicts#index'
  get 'session_conflict/:session_id', to: 'conflicts/session_conflicts#show'

  # Surveys and their nested resources
  post 'survey/:survey_id/assign_people', to: 'surveys#assign_people'
  post 'survey/:survey_id/unassign_people', to: 'surveys#unassign_people'

  resources :surveys, path: 'survey' do
    resources :pages, controller: 'survey/pages', only: [:index]
    delete 'submission', to: 'survey/submissions#delete_all'
    get 'submissions', to: 'survey/submissions#index'
    get 'submissions/flat', to: 'survey/submissions#flat'
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
  resources :application_roles, path: 'application_role'
  post 'application_role/:role_id/assign_people', to: 'application_roles#assign_people'
  post 'application_role/:role_id/unassign_people', to: 'application_roles#unassign_people'
  post 'application_role/:role_id/assign_convention_role', to: 'application_roles#assign_convention_role'
  post 'application_role/:role_id/unassign_convention_role', to: 'application_roles#unassign_convention_role'

  resources :formats, path: 'format'
  resources :areas, path: 'area'
  resources :tags, path: 'tag'
  get 'session/tags', to: 'sessions#tags'
  post 'session/import', to: 'sessions#import'
  # get sessions/assigned_id - &include=session_assignments&filter[session_assignments][person_id]=person_id
  resources :sessions, path: 'session' do
    get 'session_assignments', to: 'session_assignments#index'
    get 'areas', to: 'areas#index'
  end
  # need id of person expressing interest
  get 'session/:id/express_interest(/:person_id)', to: 'sessions#express_interest'
  resources :published_sessions, path: 'published_session'

  resources :session_assignments, path: 'session_assignment'
  get 'session_assignment/:id/unexpress_interest(/:person_id)', to: 'session_assignments#unexpress_interest'

  resources :room_sets, path: 'room_set'
  resources :rooms, path: 'room'
  resources :roomsets, path: 'roomset'
  resources :venues, path: 'venue'
  resources :tag_contexts, path: 'tag_context'
  resources :configurations, path: 'configuration'
  resources :parameter_names, path: 'parameter_name'

  resources :mailings, path: 'mailing'

  get 'mailing/preview/:id/:email', to: 'mailings#preview', constraints: { email: /[^\/]+/ }
  get 'mailing/schedule/:id(/:email)(/:test)', to: 'mailings#schedule', constraints: { email: /[^\/]+/ }
  get 'mailing/clone/:id', to: 'mailings#clone'
  post 'mailing/:mailing_id/assign_people', to: 'mailings#assign_people'
  post 'mailing/:mailing_id/unassign_people', to: 'mailings#unassign_people'

  # Access to the sidekiq monitoring app...
  authenticate :person, lambda { |p| p.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # force everything back to the SPA home page
  # This has to be at the end otherwise we do not match the resource endpoints
  # as this is a catch all
  # match '*path' => redirect('/'), via: :get
end
