class BioSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :bio, :created_at, :updated_at,
             :website, :twitter, :othersocialmedia,
             :photourl, :facebook, :linkedin, :twitch,
             :youtube, :instagram, :flickr, :reddit, :tiktok

  belongs_to :person,
    links: {
      self: -> (object, params) {
        "#{params[:domain]}/bios/#{object.id}"
      },
      related: -> (object, params) {
        "#{params[:domain]}/people/#{object.person_id}"
      }
    }
end
