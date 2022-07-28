class XmlFormatter
  attr_reader :formattable

  def initialize(formattable)
    @formattable = formattable
    # Use Nokogiri to build XML output
    @xml = Nokogiri::XML::Builder.new
  end

  def format
    render file_name, formattable, xml: @xml
  end

  def render(file_name, object, options = nil)
    file = "#{template_path}/#{file_name}.nokogiri"
    scope = Object.new
    scope.instance_variable_set :@instance, object
    # at the moment we do not have any options ... TODO: check
    Tilt.new(file).render(scope) #, options)
  end

  def template_path
    Rails.root.join("app", "views", "xml_templates")
  end

  def file_name
    formattable.class.name.downcase
  end
end
