# == Schema Information
#
# Table name: publication_statuses
#
#  id           :uuid             not null, primary key
#  lock_version :integer          default(0)
#  status       :string
#  submit_time  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class PublicationStatus < ApplicationRecord
  validates_inclusion_of :status, in: %w[inprogress completed]
end
