class Conclar::ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :bio

  attribute :name do
    object.published_name
  end

  attribute :sortname do
    object.published_name_sort_by
  end

  attribute :prog do
    res = []
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    object.session_assignments.each do |assignment|
      next if assignment.session_assignment_role_type_id != moderator.id and assignment.session_assignment_role_type_id != participant.id

      res << assignment.session_id
    end

    res
  end

  # links ????
  # what about social media URLs?
  # tags - not supported yet
end

# All participants on the schedule ...
#   var people = [
# {
# 	"id": "4567",
# 	"name": [ "Friend Andhis Jr." ],
# 	"sortname" : "Andhis Jr., Friend",
# 	"tags": [],
# 	"prog": [ "1234", "614", "801" ],
# 	"links": [],
# 	"bio": "Prior art for Adams's satirical point – that humans attach such importance to their automobiles that a visiting extraterrestrial might reasonably mistake them for the planet's dominant life form – can be found in a widely reprinted article from <i>The Rockefeller Institute Review</i> titled <i>Life on Earth (by a Martian)</i> by Paul Weiss. The idea was also expounded by Carl Sagan, though this may have postdated Adams's creation of the character of Ford. The 1967 Oscar-nominated animated film <i>What on Earth!</i> from the National Film Board of Canada is also based on this premise."
# },
# {
# 	"id": "1234",
# 	"name": [ "Galahad", "", "Sir" ],
# 	"sortname": "Sir Galahad",
# 	"tags": [ "GoH" ],
# 	"prog": [ "416" ],
# 	"links": {
# 		"img": "/images/galahad.jpg",
# 		"photo": "/images/galahad.jpg",
# 		"img_256_url": "/images/galahad.jpg",
# 		"url": "http://en.wikipedia.org/wiki/Galahad"
# 	},
# 	"bio": "Sir Galahad (/ˈɡæləhæd/; Middle Welsh: Gwalchavad, sometimes referred to as Galeas /ɡəˈliːəs/ or Galath /ˈɡæləθ/), in Arthurian legend, is a knight of King Arthur's Round Table and one of the three achievers of the Holy Grail."
# },
