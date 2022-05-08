#
# NOTE: this is a variation of the Active Model serializer, changed so that we
# can support serialization to Excel.
#
# XlsSerializer is modeled on the Active Model Serializer
# and provides a base for serializing objects to Excel.
#
module ActiveModel
  module XlsSerializerMethods
    def to_a(cols)
      return [] unless @object
      @attributes = nil

      associated_serializers

      if cols && cols.size.positive?
        cols.collect { |name| value_for_cell(read_attribute(name), name) }
      else
        @object.class.attribute_names.collect { |name| value_for_cell(@object[name.to_sym], name) }
      end
    end

    def set_object(obj)
      self.object = obj
      # TODO: other resets
    end

    def read_attribute(name)
      if self.class._attributes_data.key?(name.to_sym)
        self.class._attributes_data[name.to_sym].value(self)
      else
        val = nil
        associated_serializers unless @associated_serializers

        cname = name.split('.')
        if name.include?('responses')
          association = self._reflections[:responses].build_association(self, {})

          obj = association.object[cname[1]]

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
      return if @associated_serializers

      @associated_serializers = RequestStore.store["associated_serializers"] if RequestStore.store["associated_serializers"]

      associations.each do |association|
        @associated_serializers ||= {}
        unless @associated_serializers[association.key.to_s]
          if association.lazy_association.serializer && !@associated_serializers[association.key].present?
            @associated_serializers[association.key.to_s] = association.lazy_association.serializer
          end
        end
      end

      RequestStore.store["associated_serializers"] = @associated_serializers
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
    end

    def response_columns
      nil
    end

    def column_titles
      return attribute_names unless response_columns

      attribute_names + response_columns.collect{|e| e[:display_name]}
    end

    def column_fields
      return attribute_names unless response_columns

      attribute_names + response_columns.collect{|e| e[:name]}
    end

    def question_types
      return {} unless response_columns

      response_columns.collect{|e| {e[:name] => e[:question_type]}}.reduce({}, :merge)
    end

    def get_styles(record = nil, styles)
      res = []

      if record
        attribute_for_sheet.collect do |attribute|
          res << to_xl_style(record.class.attribute_types[attribute.to_s].class, styles)
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

    def attribute_names
      attribute_for_sheet.collect do |attribute|
        attribute.to_s
      end
    end

    def attribute_for_sheet
      self.class._attributes.difference([:lock_version, :survey_id, :person_id])
    end
  end
end
