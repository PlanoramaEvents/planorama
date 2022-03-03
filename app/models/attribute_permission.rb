class AttributePermission < ApplicationRecord
  enum action: { none: 'none', read: 'read', write: 'write' }, _suffix: true
end
