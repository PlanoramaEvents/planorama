# == Schema Information
#
# Table name: session_assignments
#
#  id                              :uuid             not null, primary key
#  interest_notes                  :text
#  interest_ranking                :integer
#  interest_role                   :enum             default("no_preference")
#  interested                      :boolean          default(FALSE)
#  lock_version                    :integer          default(0)
#  planner_notes                   :text
#  sort_order                      :integer
#  state                           :string
#  visibility                      :enum             default("is_public")
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  person_id                       :uuid             not null
#  session_assignment_role_type_id :uuid
#  session_id                      :uuid             not null
#
# Indexes
#
#  index_session_assignments_on_interest_role                    (interest_role)
#  index_session_assignments_on_session_assignment_role_type_id  (session_assignment_role_type_id)
#  pia_person_index                                              (person_id)
#  pis_prog_item_id_index                                        (session_id)
#
class SessionAssignmentSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :session_id, :sort_order, :session_assignment_role_type_id,
             :visibility, :state, :planner_notes,
             :interested, :interest_ranking, :interest_notes, :interest_role

  belongs_to :person,
             if: Proc.new { |record| record.session },
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/session_assignment/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.person.id}"
               }
             }

  belongs_to :session, lazy_load_data: true,
             if: Proc.new { |record| record.session },
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/session_assignment/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/session/#{object.session.id}"
               }
             }
end
