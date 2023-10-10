class PageContentsController < ResourceController
  SERIALIZER_CLASS = 'PageContentSerializer'.freeze
  POLICY_CLASS = 'PageContentPolicy'.freeze
  POLICY_SCOPE_CLASS = 'PageContentPolicy::Scope'.freeze

  skip_before_action :authenticate_person!, only: [:index, :show]

  def paginate
    false
  end
end
