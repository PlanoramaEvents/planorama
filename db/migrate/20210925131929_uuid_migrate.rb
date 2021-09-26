#
#
#
require 'webdack/uuid_migration/helpers'

class UuidMigrate < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        # This was done in add_uuid_to_db
        enable_extension 'pgcrypto'

        # agreements
        primary_key_to_uuid :agreements
        # bios
        primary_key_to_uuid :bios
        # category_names
        # primary_key_to_uuid :category_names
        # categories
        primary_key_and_all_references_to_uuid :categories
        # parameter_names
        # primary_key_and_all_references_to_uuid :parameter_names
        # configurations
        primary_key_to_uuid :configurations
        # conflict_exceptions
        primary_key_to_uuid :conflict_exceptions
        # email_addresses
        primary_key_to_uuid :email_addresses
        # excluded_from_survey_maps
        # primary_key_to_uuid :excluded_items_survey_maps
        # exclusions
        # primary_key_to_uuid :exclusions
        # formats
        primary_key_to_uuid :formats
        # label_dimensions
        primary_key_to_uuid :label_dimensions
        # magic_links
        primary_key_to_uuid :magic_links
        # mail_histories
        primary_key_to_uuid :mail_histories
        # mail_templates
        primary_key_to_uuid :mail_templates
        # mailings
        primary_key_to_uuid :mailings
        # person_agreements
        primary_key_to_uuid :person_agreements
        # person_constraints
        primary_key_to_uuid :person_constraints
        # person_mailing_assignments
        primary_key_to_uuid :person_mailing_assignments
        # people
        primary_key_and_all_references_to_uuid :people
        # person_roles
        primary_key_to_uuid :person_roles
        # programme_items
        primary_key_to_uuid :programme_items
        # programme_item_assignments
        primary_key_to_uuid :programme_assignments
        # programme_item_assignment_role_types
        primary_key_to_uuid :programme_assignment_role_type
        # publication_dates
        primary_key_to_uuid :publication_dates
        # publication_statuses
        primary_key_to_uuid :publication_statuses
        # published_programme_items
        # primary_key_to_uuid :published_programme_items
        # published_programme_item_assignments
        # primary_key_to_uuid :published_programme_item_assignments
        # rooms
        primary_key_to_uuid :rooms
        # surveys
        primary_key_and_all_references_to_uuid :surveys
        # survey_answers
        primary_key_to_uuid :survey_answers
        # survey_pages
        primary_key_and_all_references_to_uuid :survey_pages
        # survey_query_predicates
        primary_key_to_uuid :survey_query_predicates
        # survey_queries
        primary_key_to_uuid :survey_queries
        # survey_questions
        primary_key_and_all_references_to_uuid :survey_questions
        # survey_responses
        primary_key_and_all_references_to_uuid :survey_responses
        # survey_submissions
        primary_key_and_all_references_to_uuid :survey_submissions
        # tag_contexts
        primary_key_to_uuid :tag_contexts
        # venues
        primary_key_to_uuid :venues

        # Deal with all the relationships
        columns_to_uuid :agreements, :created_by_id, :updated_by_id
        columns_to_uuid :person_agreements, :person_id, :agreement_id
        columns_to_uuid :bios, :person_id
        # columns_to_uuid :categories, :category_name_id, :categorized_id
        # columns_to_uuid :configurations, :parameter_name_id
        columns_to_uuid :email_addresses, :person_id
        # columns_to_uuid :excluded_items_survey_maps, :programme_item_id, :survey_answer_id
        # columns_to_uuid :exclusions, :person_id, :excludable_id
        columns_to_uuid :magic_links, :person_id
        columns_to_uuid :mail_histories, :person_mailing_assignment_id, :person_id, :mailing_id
        columns_to_uuid :mail_templates, :survey_id
        columns_to_uuid :mailings, :mail_template_id
        columns_to_uuid :person_agreements, :person_id, :agreement_id
        columns_to_uuid :person_constraints, :person_id
        columns_to_uuid :person_mailing_assignments, :person_id, :mailing_id
        columns_to_uuid :person_roles, :person_id
        columns_to_uuid :programme_items, :format_id, :room_id
        columns_to_uuid :programme_assignments, :programme_assignment_role_type_id, :programme_item_id, :person_id
        columns_to_uuid :programme_assignment_role_type
        columns_to_uuid :published_programme_items, :format_id, :room_id, :programme_item_id
        columns_to_uuid :published_programme_assignments, :programme_assignment_id, :programme_item_id, :programme_assignment_role_type_id, :person_id
        columns_to_uuid :rooms, :venue_id
        columns_to_uuid :surveys, :published_by_id, :created_by_id, :updated_by_id
        columns_to_uuid :survey_answers, :survey_question_id, :next_page_id
        columns_to_uuid :survey_pages, :next_page_id, :survey_id
        columns_to_uuid :survey_query_predicates, :survey_question_id, :survey_query_id
        columns_to_uuid :survey_queries, :survey_id, :user_id
        columns_to_uuid :survey_questions, :survey_page_id
        columns_to_uuid :survey_responses, :survey_question_id, :survey_submission_id
        columns_to_uuid :survey_submissions, :survey_id, :person_id
      end

      dir.down do
        raise ActiveRecord::IrreversibleMigration
      end
    end
  end
end
