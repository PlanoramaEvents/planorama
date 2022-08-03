class PublicationStatus < ApplicationRecord
  validates_inclusion_of :status, in: %w[inprogress completed]
end
