class ActiveModel::XlsSerializer::Railtie < Rails::Railtie
  initializer 'xls_serializer' do
    ActiveSupport.on_load(:action_controller) do
      ActionController::Renderers.add :xls do |object, options|
        filename = options.fetch(:filename, 'data')
        begin
          serializer =
            if object.respond_to?(:each)
              hash = options.slice(:each_serializer)
              ActiveModel::XlsArraySerializer.new(object, hash)
            else
              hash = options.slice(:serializer)
              ActiveModel::XlsSerializerFactory.new(object, hash)
            end
          data = serializer.to_xslx
        rescue NameError
          data = object.respond_to?(:to_xls) ? object.to_xls : object.to_s
        end
        disposition = options.delete(:disposition) || 'attachment'

        send_data(
          data,
          type: Mime::XLSX,
          disposition: disposition
        )
      end
    end
  end
end
