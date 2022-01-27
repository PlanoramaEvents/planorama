require "securerandom"

# TODO: add include parameter as option
# If an endpoint does not support the include parameter,
# it MUST respond with 400 Bad Request to any requests that include it.
#
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
        options = {
          meta: meta,
          include: filtered_serializer_includes(fields: fields), # need to adjust based omn field
          params: {domain: "#{request.base_url}"}
        }
        options[:fields] = fields
        # Example for sparse field set
        # options[:fields] = {person: [:name, :email_addresses], email_address: [:email]}
        render json: serializer_class.new(@collection,options).serializable_hash(),
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
    authorize @object, policy_class: policy_class
    # give the new object a UUID ...
    @object.id = SecureRandom.uuid
    render_object(@object, includes: false)
  end

  def create
    model_class.transaction do
      authorize @object, policy_class: policy_class
      before_save
      @object.save!
      after_save
    end
    after_save_tx
    render_object(@object)
  end

  def update
    model_class.transaction do
      if @object.new_record?
        # authorize model_class, policy_class: policy_class
        authorize @object, policy_class: policy_class
        before_save
        @object.save!
        after_save
      else
        authorize @object, policy_class: policy_class
        before_update
        @object.update!(strip_params(_permitted_params(object_name)))
        @object.reload
        after_update
      end
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

  def render_object(object, serializer: nil, includes: true, jsonapi_included: nil)
    serializer_used = serializer || serializer_class
    jsonapi_included ||= serializer_includes
    if serializer_used
      options = {
        include: filtered_serializer_includes(
                   fields: fields,
                   serialized_includes: jsonapi_included
                 ),
        params: {domain: "#{request.base_url}"}
      }
      options[:fields] = fields

      render json: serializer_used.new(object, options).serializable_hash,
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

  def collection_params(do_paginate: true)
    per_page = params[:perPage]&.to_i || model_class.default_per_page if paginate && do_paginate
    per_page = nil unless paginate && do_paginate
    current_page = params[:current_page]&.to_i || 1 if paginate && do_paginate
    # Rails.logger.debug("****** #{params[:filter]}")
    filters = JSON.parse(params[:filter]) if params[:filter].present?

    return per_page, current_page, filters
  end

  def order_string(order_by: nil)
    order_str = nil

    order = order_by || params[:sortBy]
    order ||= self.class::DEFAULT_SORTBY if defined? self.class::DEFAULT_SORTBY
    order ||= ''

    if !order.blank?
      direction = params[:sortOrder]
      direction ||= self.class::DEFAULT_ORDER if defined? self.class::DEFAULT_ORDER
      direction ||= 'asc'

      order_str = "#{order} #{direction}"
      # For PSQL NULLS FIRST is the default for DESC order, and NULLS LAST otherwise.
      if direction == 'asc'
        order_str += ' NULLS FIRST'
      else
        order_str += ' NULLS LAST'
      end
    end

    order_str
  end

  def collection
    base = if belong_to_class && belongs_to_param_id
             parent = belong_to_class.find belongs_to_param_id
             parent.send(belongs_to_relationship)
           else
             model_class
           end

    @per_page, @current_page, @filters = collection_params

    q = policy_scope(base, policy_scope_class: policy_scope_class)
      .includes(includes)
      .references(references)
      .joins(join_tables)
      .where(query(@filters))
      # .joins(query_join_tables(@filters))

    q = q.order(order_string)

    if paginate
      q.page(@current_page).per(@per_page)
    else
      q
    end
  end

  def query(filters = nil)
    # Go through the filter and construct the where clause
    return nil unless filters.present?

    query_part(filter: filters)
  end

  def query_part(filter:)
    q = nil
    global_op = filter['op'] == 'all' ? :and : :or
    filter['queries'].each do |query|
      if query.is_a? Hash
        part = query_part(filter: query)
      else
        key, operation, value = query

        col_table = get_table(column: key)
        if key == 'all'
          model_class.columns.each do |col|
            next unless [:text, :string].include?(col.type)
            query_part = get_query_part(table: col_table, column: col.name, operation: 'like', value: value)
            part = part ? part.or(query_part) : query_part
          end
        else
          col = get_column(column: key)
          part = get_query_part(table: col_table, column: col, operation: operation, value: value)
        end
      end

      q = q ? q.send(global_op, part) : part
    end

    q
  end

  def get_table(column:)
    col_table = Arel::Table.new(model_class.table_name)
    col_table_name, col = column.split('.') if column.include? '.'

    if col_table_name && model_class.reflections[col_table_name].class == ActiveRecord::Reflection::HasAndBelongsToManyReflection
      # key = "#{model_class.reflections[col_table_name].join_table}.#{col}"
      col_table = Arel::Table.new("#{model_class.reflections[col_table_name].join_table}")
    elsif col_table_name && model_class.reflections[col_table_name].class == ActiveRecord::Reflection::HasManyReflection
      # need to join with the people table
      col_table = Arel::Table.new("#{col_table_name}")
    end

    return col_table
  end

  # def query_join_tables(filters = nil)
  #   return [] unless filters
  #   # TODO: create a join clause for relationships
  # end

  def get_column(column:)
    col = column
    col_table_name, col = column.split('.') if column.include? '.'

    return col
  end

  def get_query_part(table:, column:, operation:, value:)
    Rails.logger.debug "** QUERY PART #{table} #{column} #{operation} #{value}"
    op = translate_operator(operation: operation)

    val = value
    val = "%#{value}%" if op == :matches
    val = "%#{value}%" if op == :does_not_match
    val = "%#{value}" if operation == 'ends with'
    val = "#{value}%" if operation == 'begins with'
    val = "''" if operation == 'is empty'
    val = "''" if operation == 'is not empty'

    part = table[column.to_sym].send(op, val)
  end

  # Convert the operation passed in via teh filter into
  # an arel predicate op
  # is empty
  # is not empty
  # begins with
  # ends with
  def translate_operator(operation:)
    Rails.logger.debug "*** Translate op #{operation}"
    case operation.downcase
    when 'does not contain'
      :'does_not_match' # "%val%"
    when 'contains'
      :'matches' # "%val%"
    when 'like'
      :'matches' # "%val%"
    when 'equals'
      :eq
    when '='
      :eq
    when 'does not equal'
      :not_eq
    when '!='
      :not_eq
    when '<'
      :lt
    when '>'
      :gt
    when '<='
      :lteq
    when '>='
      :gteq
    when 'is empty'
      :eq
    when 'is not empty'
      :not_eq
    when 'begins with'
      :'matches'
    when 'ends with'
      :'matches'
    else
      :eq
    end
    # does_not_match, #does_not_match_all, #does_not_match_any, #does_not_match_regexp,
    # in, not_in etc
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
    elsif update_actions.include?(action)
      build_resource
    end
  end

  def find_resource
    if belongs_to_param_id && belong_to_class
      parent = belong_to_class.find belongs_to_param_id

      return nil unless policy_scope(
        parent.send(belongs_to_relationship),
        policy_scope_class: policy_scope_class
      ).exists?(resource_id)

      policy_scope(
        parent.send(belongs_to_relationship),
        policy_scope_class: policy_scope_class
      ).find(resource_id)
    else
      return nil unless policy_scope(model_class, policy_scope_class: policy_scope_class).exists?(resource_id)

      policy_scope(model_class, policy_scope_class: policy_scope_class).find(resource_id)
    end
  end

  def build_resource
    if belongs_to_param_id && belong_to_class
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

  def update_actions
    [:update]
  end

  def allowed_params
    nil
  end

  def except_params
    nil
  end

  # TODO: optimize
  def fields
    _fields = params.permit(fields: {})[:fields].to_h
    _fields.each do |k,v|
      _fields[k] = v.split(',')
    end

    _fields
  end

  def filtered_serializer_includes(fields: , serialized_includes: nil)
    serialized_includes ||= serializer_includes
    return serialized_includes if fields.empty?

    keys = fields.flatten(2)
    serialized_includes.select{|v| keys.include?(v.to_s)}
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
          except: except_params,
          # NOTE: allowed params need to include relationship name if there needed for save
          only: allowed_params
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
