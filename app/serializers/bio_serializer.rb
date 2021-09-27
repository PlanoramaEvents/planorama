class BioSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :bio, :created_at, :updated_at,
             :website, :twitter, :othersocialmedia,
             :photourl, :facebook, :linkedin, :twitch,
             :youtube, :instagram, :flickr, :reddit, :tiktok

  belongs_to :person
end
