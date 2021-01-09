module ResourceMethods
  extend ActiveSupport::Concern

  def index
    if serializer_class
      render json: {
        total: @collection_total,
        page: @page,
        perPage: @per_page,
        data: ActiveModel::Serializer::CollectionSerializer.new(
          @collection,
          serializer: serializer_class
        ).as_json
      }, content_type: 'application/json'
    else
      render json: {
        total: @collection_total,
        page: @page,
        perPage: @per_page,
        data: @collection
      }, content_type: 'application/json'
    end
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  def show
    if serializer_class && !@object.nil?
      render json: serializer_class.new(@object).to_json,
        content_type: 'application/json'
    else
      render json: @object.to_json, content_type: 'application/json'
    end
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  def create
    model_class.transaction do
      before_save
      @object.save!
      after_save
    end
    after_save_tx
    if serializer_class
      render json:  serializer_class.new(@object).to_json,
             content_type: 'application/json'
    else
      render json: @object.to_json, content_type: 'application/json'
    end
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  def update
    model_class.transaction do
      before_update
      @object.update!(strip_params(_permitted_params(object_name)))
      @object.reload
      after_update
    end
    after_update_tx
    if serializer_class
      render json:  serializer_class.new(@object).to_json,
        content_type: 'application/json'
    else
      render json: @object.to_json, content_type: 'application/json'
    end
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  def destroy
    model_class.transaction do
      @object.public_send(object_destroy_method)
      render status: :ok, text: {}.to_json
    end
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
  end

  def restore
    model_class.transaction do
      @object.public_send(object_restore_method)
      if serializer_class
        render json:  serializer_class.new(@object).to_json,
          content_type: 'application/json'
      else
        render json: @object.to_json, content_type: 'application/json'
      end
    end
  rescue => ex
    Rails.logger.error ex.message if Rails.env.development?
    Rails.logger.error ex.backtrace.join("\n\t") if Rails.env.development?
    render status: :bad_request, json: {error: ex.message}
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
    @per_page = params[:perPage]&.to_i || model_class.default_per_page
    @page = params[:page]&.to_i || 0
    @order = params[:sortField] || ''
    @direction = params[:sortOrder] || ''
    model_class
      .order("#{@order} #{@direction}")
      .page(@page)
      .per(@per_page)
  end

  def model_name
    "#{model_class}"
  end

  def model_class
    self.class::MODEL_CLASS.constantize if defined?(self.class::MODEL_CLASS)

    self.class.name.sub('Controller', '').singularize.constantize
  end

  def serializer_class
    self.class::SERIALIZER_CLASS.constantize if defined? self.class::SERIALIZER_CLASS
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
      @collection_total ||= collection.total_count

      instance_variable_set("@#{controller_name}", @collection_total)
      instance_variable_set("@#{controller_name}", @collection)
    end
  end

  def load_resource_instance
    if new_actions.include?(action)
      build_resource
    elsif resource_id
      find_resource
    end
  end

  def find_resource
    model_class.find(resource_id)
  end

  def build_resource
    model_class.new(strip_params(_permitted_params(object_name)))
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

  def _permitted_params(_object_name)
    if allowed_params
      params.permit(
        allowed_params
      )
    else
      params[_object_name]
    end
  end

  def strip_params(_permitted_params)
    return unless _permitted_params

    _permitted_params.each{|k,v| _permitted_params[k] = v&.strip if v.respond_to?(:strip)}
  end
end
