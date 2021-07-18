#
# NOTE: this is a variation of the Active Model serializer, changed so that we
# can support serialization to Excel.
#
# XlsSerializer is modeled on the Active Model Serializer
# and provides a base for serializing objects to Excel.
#
module ActiveModel
  module XlsSerializerMethods
    def to_a
      return [] unless @object
      @attributes = nil

      associated_serializers

      @object.class.attribute_names.collect { |name| value_for_cell(@object[name.to_sym], name) }
    end

    def set_object(obj)
      self.object = obj
      # TODO: other resets
    end

    def read_attribute(name)
      Rails.logger.error "*** READ #{name}"
      if self.class._attributes_data.key?(name.to_sym)
        self.class._attributes_data[name.to_sym].value(self)
      else
        val = nil
        associated_serializers unless @associated_serializers

        cname = name.split('.')
        if name.include?('survey_responses')
          association = self._reflections[:survey_responses].build_association(self, {})

          obj = association.object[cname[1].to_i]

          if obj && obj.is_a?(String)
            val = obj
          elsif obj && obj.serializer_instance
            val = obj.serializer_instance.class._attributes_data[:response].value(obj.serializer_instance)
          end
        else
          if @associated_serializers && @associated_serializers[cname[0]] && !cname[1].blank?
            association_serializer = @associated_serializers[cname[0]]
            association = self._reflections[cname[0].to_sym].build_association(self, {})
            association_serializer.object = association.object

            if association_serializer.class._attributes_data[cname[1].to_sym] && association.object
              val = association_serializer.class._attributes_data[cname[1].to_sym].value(association_serializer)
            end
          end
        end

        val
      end
    end

    def associated_serializers
      associations.each do |association|
        @associated_serializers ||= {}
        unless @associated_serializers[association.key.to_s]
          if association.lazy_association.serializer && !@associated_serializers[association.key].present?
            @associated_serializers[association.key.to_s] = association.lazy_association.serializer
          end
        end
      end
    end

    def value_for_cell(val, name)
      if val.kind_of?(Array)
        val.join(', ')
      else
        coerce(val, name)
      end
    end

    def coerce(val, name)
      return unless val

      if val.class == ActiveSupport::TimeWithZone
        return FastExcel.date_num(val, val.in_time_zone.utc_offset)
      else
        val
      end

      # case val.class.name
      # when 'DateTime'
      #   Rails.logger.debug("**** datetime")
      #
      #   FastExcel.date_num(val, val.in_time_zone.utc_offset) if val
      # when :Time
      #   Rails.logger.debug("**** time")
      #
      #   FastExcel.date_num(val, val.in_time_zone.utc_offset) if val
      # when 'ActiveSupport::TimeWithZone'
      #   Rails.logger.debug("**** time with zone")
      #   FastExcel.date_num(val, val.in_time_zone.utc_offset) if val
      # when 'TrueClass'
      #   val == true
      # when 'FalseClass'
      #   val == true
      # else
        # val
      # end
    end

    def response_columns
      nil
    end

    def column_titles(cols = nil)
      return attribute_names
    end

    def get_styles(record = nil, styles)
      res = []

      if record
        record.class.attribute_types.each do |r|
          res << to_xl_style(r[1].class, styles)
        end
      end

      res
    end

    def to_xl_style(type, styles)
      if type == ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter
        styles[:datetime]
      else
        nil
      end
    end

    def attribute_names(cols = nil)
      return cols if cols && cols.size.positive?

      if self.class.method_defined? '_attributes'
        self.class._attributes.collect do |attribute|
          attribute.to_s
        end
      else
        @object.class.attribute_names
      end
    end
  end
end
