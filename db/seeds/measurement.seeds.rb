p "Start measurement seeds"


unless LinearUnit.find_by(name: 'inch')
  LinearUnit.create!(
      name: "inch",
      measurement_system: :Imperial
  )
end

unless LinearUnit.find_by(name: 'feet')
  LinearUnit.create!(
      name: "feet",
      measurement_system: :Imperial
  )
end

unless LinearUnit.find_by(name: 'centimeter')
  LinearUnit.create!(
      name: "centimeter",
      measurement_system: :Metric
  )
end

unless LinearUnit.find_by(name: 'meter')
  LinearUnit.create!(
      name: "meter",
      measurement_system: :Metric
  )
end

unless AreaUnit.find_by(name: 'square meters')
  AreaUnit.create!(
      name: "square meters",
      measurement_system: :Metric
  )
end

unless AreaUnit.find_by(name: 'square feet')
  AreaUnit.create!(
      name: "square feet",
      measurement_system: :Imperial
  )
end



p "End measurement seeds"
