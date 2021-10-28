require "securerandom"

module ResourceMethods
  extend ActiveSupport::Concern
  include JSONAPI::Deserialization

  def index
    authorize model_class, policy_class: policy_class

    meta = {}
    meta[:total] = @collection_total if paginate
    meta[:current_page] = @current_page if @current_page.present? && paginate
    meta[:perPage] = @per_page if @per_page.present? && paginate
    format = params[:format]

    if format == 'xls' || format == 'xlsx'
      if belongs_to_param_id
        generate_xls(xls_serializer_class, { serializer: { model_id: belongs_to_param_id } })
      else
        generate_xls
      end
    else
      if serializer_class
        render json: serializer_class.new(@collection,
                      {
                        meta: meta,
                        include: serializer_includes,
                        params: {domain: "#{request.base_url}"}
                      }
                    ).serializable_hash(),
               content_type: 'application/json'
      else
        render json: @collection,
               meta: meta,
               root: 'data',
               adapter: :json,
               content_type: 'application/json'
      end
    end
  end

  def show
    authorize @object, policy_class: policy_class
    render_object(@object)
  end

  # creates a new instance but does not save it to the db
  # Frontend could use this as a template
  # endpoint like /person/new
  def new
    authorize model_class, policy_class: policy_class
    # give the new object a UUID ...
    @object.id = SecureRandom.uuid
    render_object(@object, includes: false)
  end

  def create
    model_class.transaction do
      authorize model_class, policy_class: policy_class
      before_save
      @object.save!
      after_save
    end
    after_save_tx
    render_object(@object)
  end

  def update
    model_class.transaction do
      authorize @object, policy_class: policy_class
      before_update
      @object.update!(strip_params(_permitted_params(object_name)))
      @object.reload
      after_update
    end
    after_update_tx
    render_object(@object)
  end

  def destroy
    model_class.transaction do
      authorize @object, policy_class: policy_class
      @object.public_send(object_destroy_method)
      render status: :ok, json: {}.to_json, content_type: 'application/json'
    end
  end

  def restore
    model_class.transaction do
      authorize @object, policy_class: policy_class
      @object.public_send(object_restore_method)
      render_object(@object)
    end
  end

  def render_object(object, serializer: nil, includes: true)
    serializer_used = serializer || serializer_class
    if serializer_used
      render json: serializer_used.new(
                    object,
                    {
                      include: (includes ? serializer_includes : []),
                      params: {domain: "#{request.base_url}"}
                    }
                   ).serializable_hash,
             content_type: 'application/json'
    else
      render json: object,
             content_type: 'application/json'
    end
  end

  def before_update
  end

  def before_save
  end

  def after_update
  end

  def after_save
  end

  def after_save_tx
  end

  def after_update_tx
  end

  def object_destroy_method
    :destroy
  end

  def object_restore_method
  end

  def action
    params[:action].to_sym
  end

  def collection
    base = if belong_to_class
             parent = belong_to_class.find belongs_to_param_id
             parent.send(belongs_to_relationship)
           else
             model_class
           end

    @per_page = params[:perPage]&.to_i || model_class.default_per_page if paginate
    @per_page = nil unless paginate
    @current_page = params[:currentPage]&.to_i || 0 if paginate
    # Sort field could come from the nested object
    @order = params[:sortBy]
    @order ||= self.class::DEFAULT_ORDER if defined? self.class::DEFAULT_ORDER
    @order ||= ''
    @direction = params[:sortOrder] || 'asc'
    @filters = JSON.parse(params[:filter]) if params[:filter].present?

    q = policy_scope(base, policy_scope_class: policy_scope_class)
      .includes(includes)
      .references(references)
      .joins(join_tables)
      .where(query(@filters))

    # For PSQL NULLS FIRST is the default for DESC order, and NULLS LAST otherwise.
    if !@order.blank?
      order_str = "#{@order} #{@direction}"
      if @direction == 'asc'
        order_str += ' NULLS FIRST'
      else
        order_str += ' NULLS LAST'
      end
      q = q.order(order_str)
    end

    if paginate
      q.page(@current_page).per(@per_page)
    else
      q
    end
  end

  def query(filters = nil)
    # Go through the filter and construct the where clause
    return nil unless filters.present?

    table = Arel::Table.new(model_class.table_name)
    q = nil
    filters.each do |k,v|
      next unless v.present?

      a = "#{k}"
      a.slice!('$.')
      type = model_class.columns_hash[a].type

      case type
      when :integer
        part = table[a.to_sym].eq(v.to_i)
      when :boolean
        part = table[a.to_sym].eq(['true', true, 1].include?(v))
      when :string
        part = table[a.to_sym].matches("%#{v}%")
      else
        part = table[a.to_sym].matches("%#{v}%")
      end

      q = q ? q.and(part) : part
    end

    q
  end

  def model_name
    "#{model_class}"
  end

  def model_class
    if defined?(self.class::MODEL_CLASS)
      self.class::MODEL_CLASS.constantize
    else
      self.class.name.sub('Controller', '').singularize.constantize
    end
  end

  def serializer_class
    self.class::SERIALIZER_CLASS.constantize if defined? self.class::SERIALIZER_CLASS
  end

  def generate_xls(serializer = nil, opts = {})
    opts[:each_serializer] = serializer ? serializer : xls_serializer_class
    cookies[:fileDownload] = true
    fname = self.class::XLS_SERIALIZER_FILENAME if defined? self.class::XLS_SERIALIZER_FILENAME
    fname ||= controller_name.downcase
    send_data ActiveModel::XlsArraySerializer.new(
      @collection,
      opts
    ).to_xls,
    filename: "#{fname}_#{Time.now.strftime('%m-%d-%Y')}.xlsx",
    disposition: 'attachment'
  end

  def xls_serializer_class
    return self.class::XLS_SERIALIZER_CLASS.constantize if defined? self.class::XLS_SERIALIZER_CLASS

    'ActiveModel::XlsSerializer'.constantize
  end

  # authorize @publication, policy_class: PublicationPolicy
  def policy_class
    # return an overide for policy class if there is one
    return self.class::POLICY_CLASS.constantize if defined? self.class::POLICY_CLASS

    # else use the 'global' policy
    # TODO: global policy class

    # if we return none then Pundit's policy finder will be used ...
    return PlannerPolicy
  end

  def policy_scope_class
    return self.class::POLICY_SCOPE_CLASS.constantize if defined? self.class::POLICY_SCOPE_CLASS

    PlannerPolicy::Scope
  end

  def object_name
    controller_name.singularize
  end

  def resource_id
    params[:id]
  end

  def load_resource
    if member_action?
      @object ||= load_resource_instance

      instance_variable_set("@#{object_name}", @object)
    else
      @collection ||= collection
      @collection_total ||= collection.total_count if paginate
      @collection_total ||= collection.size unless paginate

      instance_variable_set("@#{controller_name}", @collection_total)
      instance_variable_set("@#{controller_name}", @collection)
    end
  end

  def load_resource_instance
    if new_actions.include?(action)
      build_resource
    elsif resource_id
      # JSON api could send a resource with UUID generated
      # client side. If we do not find it in the DB we then
      # will create it!
      find_resource || build_resource
    end
  end

  def find_resource
    if belong_to_class
      parent = belong_to_class.find belongs_to_param_id
      policy_scope(
        parent.send(belongs_to_relationship),
        policy_scope_class: policy_scope_class
      ).find(resource_id)
    else
      policy_scope(model_class, policy_scope_class: policy_scope_class).find(resource_id)
    end
  end

  def build_resource
    if belong_to_class
      parent = belong_to_class.find belongs_to_param_id
      parent.send(belongs_to_relationship).new(strip_params(_permitted_params(object_name)))
    else
      model_class.new(strip_params(_permitted_params(object_name)))
    end
  end

  def collection_actions
    [:index]
  end

  def member_action?
    !collection_actions.include? action
  end

  def new_actions
    [:new, :create]
  end

  def allowed_params
    nil
  end

  def except_params
    nil
  end

  def serializer_includes
    []
  end

  def includes
    []
  end

  def references
    []
  end

  def join_tables
    []
  end

  def belongs_to_param_id
    nil
  end

  def belong_to_class
    nil
  end

  def belongs_to_relationship
    nil
  end

  def paginate
    true
  end

  def permitted_params
    _permitted_params(object_name)
  end

  def _permitted_params(_object_name)
    # NOTE: if params[:data] to determine if this is JSON-API packet
    # that is received, if so we need to deserialize it
    if params[:data]
      # NOTE: JSPON API does not save nested data structures ....
      jsonapi_deserialize(
        params,
        {
          only: allowed_params,
          except: except_params
        }
      )
    else
      # We treat this as a regular rails request
      return params.require(_object_name).permit! unless allowed_params || params[:action] == 'new'

      params.permit(
        allowed_params
      )
    end
  end

  def strip_params(_permitted_params)
    return unless _permitted_params

    _permitted_params.each{|k,v| _permitted_params[k] = v&.strip if v.respond_to?(:strip)}
  end
end
