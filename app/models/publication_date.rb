# == Schema Information
#
# Table name: publication_dates
#
#  id                  :uuid             not null, primary key
#  dropped_assignments :integer          default(0)
#  dropped_sessions    :integer          default(0)
#  lock_version        :integer          default(0)
#  new_assignments     :integer          default(0)
#  new_sessions        :integer          default(0)
#  sent_external       :boolean          default(FALSE), not null
#  timestamp           :datetime
#  updated_assignments :integer          default(0)
#  updated_sessions    :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class PublicationDate < ApplicationRecord
  has_many :publish_snapshots do
    def schedules
      where("publish_snapshots.label = 'schedule'")
    end
    def participants
      where("publish_snapshots.label = 'participants'")
    end
  end
end
