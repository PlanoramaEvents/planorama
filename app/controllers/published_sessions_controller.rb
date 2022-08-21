class PublishedSessionsController < ResourceController
  SERIALIZER_CLASS = 'PublishedSessionSerializer'.freeze
  POLICY_CLASS = 'PublishedSessionPolicy'.freeze
#
end
