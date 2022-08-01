class PublishSnapshot < ApplicationRecord
  validates_inclusion_of :label, in: %w[schedule participants]

  belongs_to :publication_date
end
