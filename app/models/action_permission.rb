# CREATE TABLE public.action_permissions (
#     id uuid DEFAULT public.gen_random_uuid() NOT NULL,
#     mdl_name character varying,
#     action character varying,
#     allowed boolean DEFAULT false,
#     person_role_id uuid,
#     lock_version integer,
#     created_at timestamp(6) without time zone NOT NULL,
#     updated_at timestamp(6) without time zone NOT NULL,
#     action_scope string
# );
# TODO
class ActionPermission < ApplicationRecord
  # enum action_scope: { none: 'none', owner: 'owner', role: 'role' }, _suffix: true

  #  role -> action_permission
  # model, action, allowed

  belongs_to :person_role
end
