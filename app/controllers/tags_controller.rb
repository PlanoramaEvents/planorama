class TagsController < ResourceController
  SERIALIZER_CLASS = 'TagSerializer'.freeze
  POLICY_CLASS = 'TagsPolicy'.freeze
  POLICY_SCOPE_CLASS = 'TagsPolicy::Scope'.freeze

  MODEL_CLASS = 'ActsAsTaggableOn::Tag'.freeze

  DEFAULT_SORTBY = 'name'.freeze

  def includes
    [
      :taggings
    ]
  end

  def references
    [
      :taggings
    ]
  end


  def paginate
    false
  end
end
