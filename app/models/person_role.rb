# CREATE TABLE public.person_roles (
#     id uuid DEFAULT public.gen_random_uuid() NOT NULL,
#     created_at timestamp(6) without time zone NOT NULL,
#     updated_at timestamp(6) without time zone NOT NULL,
# =>  can access sensitive data
#     Add links to action permissions
# );
# TODO
class PersonRole < ApplicationRecord
  has_many :action_permissions

  validates :name, presence: true
end
