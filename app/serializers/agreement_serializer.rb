class AgreementSerializer
  include JSONAPI::Serializer

  attributes :id, :created_at, :updated_at, :lock_version,
             :target, :title, :terms, :agreement_type

  # TODO: need type??
  belongs_to :created_by, serializer: PersonSerializer

  belongs_to :updated_by, serializer: PersonSerializer
end
