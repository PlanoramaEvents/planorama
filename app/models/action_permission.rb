class ActionPermission < ApplicationRecord
  enum action_scope: { none: 'none', owner: 'owner', role: 'role' }, _suffix: true
end
