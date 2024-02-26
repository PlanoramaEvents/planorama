class CuratedTagsController < ResourceController
  MODEL_CLASS = 'CuratedTag'.freeze
  SERIALIZER_CLASS = 'CuratedTagSerializer'.freeze
  POLICY_CLASS = 'CuratedTagPolicy'.freeze
  POLICY_SCOPE_CLASS = 'CuratedTagPolicy::Scope'.freeze

  # Need context from the request
  #  index has the context
  def collection_where
    permitted = params.permit(allowed_params)
    context = permitted[:context]
    table = Arel::Table.new(model_class.table_name)

    table[:context].eq(context) if context
  end

  def paginate
    false
  end

  def allowed_params
    %i[
      id
      lock_version
      name
      context
    ]
  end
end
