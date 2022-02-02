class SessionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :title, :description,
             :duration, :minimum_people, :maximum_people,
             :item_notes, :pub_reference_number, :audience_size,
             :participant_notes, :is_break, :start_time,
             :visibility, :publish,
             :open_for_interest, :instructions_for_interest,
             :require_signup, :waiting_list_size

  # tag_list
  attribute :tag_list do |session|
    session.base_tags.collect(&:name)
  end

  # Return the assignments to this session for the person logged in (if any)
  has_one :my_assignment, serializer: SessionAssignmentSerializer do |session, params|
    if params[:current_person]
      session.session_assignments.for_person(params[:current_person].id).first
    end
  end

  has_many :areas, serializer: AreaSerializer,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/session/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/session/#{object.id}/areas"
             }
           }

  has_many :session_assignments, serializer: SessionAssignmentSerializer,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/session/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/session/#{object.id}/session_assignments"
             }
           }

  has_one :format,
          if: Proc.new { |record| record.format },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/format/#{object.format.id}"
            }
          }

  has_one :room,
          if: Proc.new { |record| record.room },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/session/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/room/#{object.room.id}"
            }
          }
end
