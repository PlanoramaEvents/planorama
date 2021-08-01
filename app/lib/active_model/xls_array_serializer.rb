# require 'csv'
require 'active_support/inflections'

module ActiveModel
  class XlsArraySerializer
    def initialize(objects, options = {})
      @each_serializer = options[:each_serializer]
      @objects = objects
      @options = options
    end

    def to_xls
      options_hash = @options.slice(:serializer)

      styles = []

      serializer = @each_serializer || ActiveModel::XlsSerializerFactory
      # 1. Create workbook
      workbook = FastExcel.open(constant_memory: true) # creates tmp file
      worksheet = workbook.add_worksheet("Export")

      date_time_style = workbook.number_format("d mmm yyyy h:mm")
      date_style = workbook.number_format("d mmm yyyy")
      time_style = workbook.number_format("h:mm")

      first = true
      # use one serializer and reset the object instead of reinstatiate
      the_serializer = serializer.new(@objects.first, options_hash)
      @objects.each do |record|
        # set the object to use for this row
        the_serializer.set_object record

        # 2. Create columns headers - this is the first row
        if first
          worksheet.append_row(
            the_serializer.column_titles
          )
          styles = the_serializer.get_styles(
            record,
            {
              datetime: date_time_style,
              date: date_style,
              time: time_style
            }
          )
        end

        row = the_serializer.to_a(the_serializer.column_fields)
        worksheet.append_row(
          row,
          styles
        )
        first = false
      end
      # 4. Send back the workbook
      workbook.read_string
    end
  end
end
