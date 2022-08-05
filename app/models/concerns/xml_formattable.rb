module XmlFormattable
  def to_xml
    formatter.format
  end

  def render(file_name, object, options = nil)
    formatter.render(file_name, object, options)
  end

  def formatter
    @formatter ||= XmlFormatter.new(self)
  end
end
