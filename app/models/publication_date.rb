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
