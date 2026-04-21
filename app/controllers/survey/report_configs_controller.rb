class Survey::ReportConfigsController < ResourceController
  MODEL_CLASS = 'Survey::ReportConfig'.freeze
  SERIALIZER_CLASS = 'Survey::ReportConfigSerializer'.freeze
  DEFAULT_SORTBY = 'sort_order'
  POLICY_CLASS = 'Survey::ReportConfigPolicy'.freeze
  POLICY_SCOPE_CLASS = 'Survey::ReportConfigPolicy::Scope'.freeze

  # NOTE: just index for now

  def paginate
    false
  end
end