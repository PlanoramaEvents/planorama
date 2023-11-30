# == Schema Information
#
# Table name: person_constraints
#
#  id                :uuid             not null, primary key
#  lock_version      :integer          default(0)
#  max_items_per_con :integer
#  max_items_per_day :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  person_id         :uuid
#
class PersonConstraints < ApplicationRecord
  belongs_to :person

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at, :lock_version]
end
