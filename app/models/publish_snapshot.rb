# == Schema Information
#
# Table name: publish_snapshots
#
#  id                  :uuid             not null, primary key
#  label               :string
#  snapshot            :jsonb
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  publication_date_id :uuid
#
class PublishSnapshot < ApplicationRecord
  validates_inclusion_of :label, in: %w[schedule participants]

  belongs_to :publication_date
end
