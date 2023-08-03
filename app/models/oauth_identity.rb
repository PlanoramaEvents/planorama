class OauthIdentity < ApplicationRecord
  belongs_to :person, optional: true
end
