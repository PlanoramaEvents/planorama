# Produce a schedule suitable for Conclar
class ScheduleController < ApplicationController
  skip_before_action :check_up, :authenticate_person!, only: [:index, :participants]

  def index
    # TODO: we really need to use published sessions, this is fine for testing for now
    sessions = ReportsService.scheduled_sessions

    render plain: "var program = " + ActiveModel::Serializer::CollectionSerializer.new(
              sessions,
              serializer: Conclar::SessionSerializer
            ).to_json
  end

  def participants
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
  end
end
