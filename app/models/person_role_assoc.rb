# CREATE TABLE public.person_role_assocs (
#     id uuid DEFAULT public.gen_random_uuid() NOT NULL,
#     person_id uuid,
#     person_role_id uuid,
#     lock_version integer,
#     created_at timestamp(6) without time zone NOT NULL,
#     updated_at timestamp(6) without time zone NOT NULL
# );
class PersonRoleAssoc < ApplicationRecord
  belongs_to :person
  belongs_to :person_role
end
