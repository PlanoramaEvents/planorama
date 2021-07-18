require 'active_support/inflections'

module ActiveModel
  module XlsSerializerFactory
    def self.new(object, options = {})
      return ActiveModel::XlsSerializer.new(nil) if object.nil?

      klass = object.model_name.name + 'XlsSerializer'
      klass = 'XlsSerializer' unless Object.const_defined?(klass)
      klass.constantize.new(object, options)
    end
  end
end
