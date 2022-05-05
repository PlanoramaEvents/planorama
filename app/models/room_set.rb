class RoomSet < ApplicationRecord
    include RankedModel
    ranks :sort_order
    
    validates_presence_of :name
end
