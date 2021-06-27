#
#
#
module ConfigService
  def self.value(name)
    v = Configuration.find_by(parameter: name)
    v ? v.parameter_value : nil
  end

  def self.value?(name)
    v = Configuration.find_by(parameter: name)
    v ? v.parameter_value.in?(['true', true, 1, '1']) : false
  end

  def self.value_present?(name)
    Configuration.find_by(parameter: name).present?
  end
end
