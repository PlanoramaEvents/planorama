#     id uuid DEFAULT public.gen_random_uuid() NOT NULL,
#     person_id uuid,
#     application_role_id uuid,
#     lock_version integer,
#     created_at timestamp(6) without time zone NOT NULL,
#     updated_at timestamp(6) without time zone NOT NULL
class ApplicationRoleAssoc < ApplicationRecord
  belongs_to :person
  belongs_to :application_role

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at]
end
