require "sidekiq/web"

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # OAuth Callbacks - provider is clyde for G24 reg etc, based on OAuth strategy
  match "/auth/:provider/callback" => "auth/omniauth_callbacks#create", via: [:get, :post]
  get '/auth/failure', to: "auth/omniauth_callbacks#failure"

  devise_for :people, path: 'auth',
             controllers: {
               sessions: 'people/sessions',
               passwords: 'people/passwords',
               registrations: 'people/registrations',
               unlocks: 'people/unlocks'
               # UnlocksController
             }, defaults: { format: :json }

  root to: 'home#index'

  get '/login/:magic_link', to: 'login#magic_link'
  post '/login/sign_up', to: 'login#sign_up'
  put '/login/complete_sign_up', to: 'login#complete_sign_up'

  post '/validator/email', to: 'validator/email#validate'

  get '/settings', to: 'settings#index'

  get '/conclar/schedule', to: 'schedule#index'
  get '/conclar/participants', to: 'schedule#participants'

  # REST based resources
  get 'person/session/me', to: 'people#me'
  get 'person/me', to: 'people#me'
  get 'people/me', to: 'people#me'
  post 'person/import', to: 'people#import'
  post 'person/update_all', to: 'people#update_all'
  post 'person/session_names', to: 'people#session_names'
  post 'person/check_password', to: 'people#check_password'
  resources :people, path: 'person' do
    # TODO: surveys
    get 'convention_roles', to: 'convention_roles#index'
    get 'email_addresses', to: 'email_addresses#index'
    get 'sessions', to: 'sessions#index'
    get 'live_sessions', to: 'people#live_sessions'
    get 'snapshot_schedule(/:label)', to: 'people#snapshot_schedule'
    get 'person_schedule_approvals', to: 'person_schedule_approvals#index'
    get 'published_sessions', to: 'published_sessions#index'
    get 'mail_histories', to: 'mail_histories#index'
    get 'submissions', to: 'people#submissions'
    get 'completed_surveys', to: 'people#completed_surveys'
    get 'resync_airmeet', to: 'people#resync_airmeet'
    resources :availabilities, path: 'availability', only: [:index]
    patch 'availability', to: 'availabilities#replace'
    resources :person_exclusions, path: 'person_exclusion', only: [:index]
    patch 'person_exclusion', to: 'person_exclusions#replace'
    resources :session_limits, path: 'session_limit', only: [:index]
    # patch 'session_limit', to: 'session_limits#replace'
    post 'clyde_sync', to: 'people#clyde_sync'
    post 'unlink_registration', to: 'people#unlink_registration'
  end
  get 'person/:person_id(/survey/:survey_id)/submissions', to: 'people#submissions'
  get 'person/:person_id/mailed_surveys', to: 'people#mailed_surveys'
  get 'person/:person_id/assigned_surveys', to: 'people#assigned_surveys'

  get 'publications/schedule', to: 'publications#schedule'

  get 'report/participant_selections', to: 'reports#participant_selections'
  get 'report/session_selections', to: 'reports#session_selections'
  get 'report/participant_availabilities', to: 'reports#participant_availabilities'
  get 'report/assigned_sessions_by_participant', to: 'reports#assigned_sessions_by_participant'
  get 'report/sessions_with_participants', to: 'reports#sessions_with_participants'
  get 'report/schedule_by_person', to: 'reports#schedule_by_person'
  get 'report/schedule_by_room_then_time', to: 'reports#schedule_by_room_then_time'
  get 'report/people_and_submissions', to: 'reports#people_and_submissions'
  get 'report/schedule_accpetance', to: 'reports#schedule_accpetance'
  get 'report/participant_do_not_assign_with', to: 'reports#participant_do_not_assign_with'
  get 'report/session_reports/panels_with_too_few_people', to: 'reports/session_reports#panels_with_too_few_people'
  get 'report/session_reports/panels_with_too_many_people', to: 'reports/session_reports#panels_with_too_many_people'

  get 'report/session_reports/invited_accepted_not_scheduled', to: 'reports/session_reports#invited_accepted_not_scheduled'
  get 'report/session_reports/session_with_no_moderator', to: 'reports/session_reports#session_with_no_moderator'
  get 'report/session_reports/assigned_sessions_not_scheduled', to: 'reports/session_reports#assigned_sessions_not_scheduled'
  get 'report/session_reports/session_copy_edit_status', to: 'reports/session_reports#session_copy_edit_status'
  get 'report/session_reports/daily_grid', to: 'reports/session_reports#daily_grid'
  get 'report/session_reports/streamed_and_recorded', to: 'reports/session_reports#streamed_and_recorded'
  get 'report/session_reports/session_needs', to: 'reports/session_reports#session_needs'
  get 'report/session_reports/scheduled_session_no_people', to: 'reports/session_reports#scheduled_session_no_people'
  get 'report/session_reports/non_accepted_on_schedule', to: 'reports/session_reports#non_accepted_on_schedule'
  get 'report/session_reports/participants_over_session_limits', to: 'reports/session_reports#participants_over_session_limits'
  get 'report/session_reports/participants_over_con_session_limits', to: 'reports/session_reports#participants_over_con_session_limits'

  get 'report/conflict_reports/people_outside_availability', to: 'reports/conflict_reports#people_outside_availability'
  get 'report/conflict_reports/people_double_booked', to: 'reports/conflict_reports#people_double_booked'
  get 'report/conflict_reports/back_to_back', to: 'reports/conflict_reports#back_to_back'
  get 'report/conflict_reports/back_to_back_to_back', to: 'reports/conflict_reports#back_to_back_to_back'
  get 'report/conflict_reports/person_exclusion_conflicts', to: 'reports/conflict_reports#person_exclusion_conflicts'
  get 'report/conflict_reports/multiple_sessions_in_room', to: 'reports/conflict_reports#multiple_sessions_in_room'
  get 'report/conflict_reports/all_conflicts', to: 'reports/conflict_reports#all_conflicts'
  get 'report/conflict_reports/all_ignored_conflicts', to: 'reports/conflict_reports#all_ignored_conflicts'

  get 'report/people_reports/record_stream_permissions', to: 'reports/people_reports#record_stream_permissions'
  get 'report/people_reports/moderators', to: 'reports/people_reports#moderators'
  get 'report/people_reports/mis_matched_envs', to: 'reports/people_reports#mis_matched_envs'
  get 'report/people_reports/social_media', to: 'reports/people_reports#social_media'

  get 'report/program_ops_reports/back_of_badge', to: 'reports/program_ops_reports#back_of_badge'
  get 'report/program_ops_reports/virtual_people', to: 'reports/program_ops_reports#virtual_people'
  get 'report/program_ops_reports/room_signs', to: 'reports/program_ops_reports#room_signs'
  get 'report/program_ops_reports/session_minors', to: 'reports/program_ops_reports#session_minors'
  get 'report/program_ops_reports/sign_up_sessions', to: 'reports/program_ops_reports#sign_up_sessions'
  get 'report/program_ops_reports/table_tents', to: 'reports/program_ops_reports#table_tents'
  get 'report/program_ops_reports/user_privileges', to: 'reports/program_ops_reports#user_privileges'

  get 'report/integrations_reports/airmeet_magic_link', to: 'reports/integrations_reports#airmeet_magic_link'
  get 'report/integrations_reports/airmeet_diffs', to: 'reports/integrations_reports#airmeet_diffs'

  get 'report/schedule_reports/schedule_diff(/:from)(/:to)', to: 'reports/schedule_reports#schedule_diff'
  get 'publication_date/reset', to: 'publication_dates#reset'
  resources :publication_dates, path: 'publication_date', only: [:index, :update]
  resources :integrations, path: 'integration', only: [:index, :update]
  get 'integration/airmeet', to: 'integrations#airmeet'
  get 'integration/clyde', to: 'integrations#clyde'
  get 'integration/g24rce', to: 'integrations#g24rce'

  get 'rce/schedule', to: 'rce#schedule'

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

  get 'session_conflict/ignore/:conflict_type/:conflict_id', to: 'conflicts/session_conflicts#ignore'
  get 'session_conflict/conflicts_for/:session_id', to: 'conflicts/session_conflicts#conflicts_for'
  get 'session_conflict/conflicts_with/:session_id', to: 'conflicts/session_conflicts#conflicts_with'

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
  # TODO: check
  resources :tags, path: 'tag'

  get 'session/tags', to: 'sessions#tags'
  get 'session/labels', to: 'sessions#labels'
  get 'session/schedule_publish', to: 'sessions#schedule_publish'
  get 'session/open_for_interest', to: 'sessions#has_open_for_interest'
  post 'session/import', to: 'sessions#import'
  post 'session/update_all', to: 'sessions#update_all'
  # get sessions/assigned_id - &include=session_assignments&filter[session_assignments][person_id]=person_id
  resources :sessions, path: 'session' do
    get 'session_assignments', to: 'session_assignments#index'
    get 'areas', to: 'areas#index'
  end
  # need id of person expressing interest
  get 'session/:id/express_interest(/:person_id)', to: 'sessions#express_interest'
  resources :published_sessions, path: 'published_session' do
    get 'resync_airmeet', to: 'published_sessions#resync_airmeet'
  end

  resources :session_assignments, path: 'session_assignment'
  get 'session_assignment/:id/unexpress_interest(/:person_id)', to: 'session_assignments#unexpress_interest'

  resources :room_sets, path: 'room_set'
  resources :rooms, path: 'room'
  resources :roomsets, path: 'roomset'
  resources :venues, path: 'venue'
  resources :tag_contexts, path: 'tag_context'
  resources :configurations, path: 'configuration'
  resources :parameter_names, path: 'parameter_name'
  resources :page_contents, path: 'page_content'

  #
  get 'registration_sync_data/sync_statistics', to: 'registration_sync_data#sync_statistics'
  get 'registration_sync_data/synchronize', to: 'registration_sync_data#synchronize'
  resources :registration_sync_data, path: 'registration_sync_datum' do
    # This needs to work a bit different than the other sub relationships
    get 'people', to: 'registration_sync_data#people'
  end

  get 'person_sync_datum/possible_match_count', to: 'person_sync_data#possible_match_count'
  post 'person_sync_datum/dismiss_match', to: 'person_sync_data#dismiss_match'
  post 'person_sync_datum/match', to: 'person_sync_data#match'
  resources :person_sync_data, path: 'person_sync_datum'

  # Curated tags are the list of tags for a given context etc
  resources :curated_tags, path: 'curated_tag'

  get 'person_schedule_approval/fetch/:person_id/:workflow_id', to: 'person_schedule_approvals#fetch'
  post 'person_schedule_approval/approve/:person_id/:workflow_id', to: 'person_schedule_approvals#approve'
  resources :person_schedule_approvals, path: 'person_schedule_approval'

  get 'schedule_workflow/reset', to: 'schedule_workflows#reset'
  resources :schedule_workflows, path: 'schedule_workflow'
  resources :schedule_snapshots, path: 'schedule_snapshot'
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
  get '*path', to: 'home#index', constraints: -> (request) do
    !request.xhr? && request.format.html?
    #  && !request.path.include?('/auth')
  end
end
