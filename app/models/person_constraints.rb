class PersonConstraints < ApplicationRecord
  belongs_to :person

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at, :lock_version]
end
