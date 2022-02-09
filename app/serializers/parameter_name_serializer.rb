class ParameterNameSerializer
  include JSONAPI::Serializer

  attributes :parameter_name, :parameter_description, :parameter_type

  has_one :configuration, serializer: ConfigurationSerializer


  # has_one :bio,
  #         if: Proc.new { |record| record.bio },
  #         links: {
  #           self: -> (object, params) {
  #             "#{params[:domain]}/person/#{object.id}"
  #           },
  #           related: -> (object, params) {
  #             "#{params[:domain]}/bio/#{object.bio.id}"
  #           }
  #         }

end
