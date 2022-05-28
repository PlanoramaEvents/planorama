p "Start development format seeds"

unless Format.find_by_name('Dev Panel')
  Format.create!(
    name: 'Dev Panel'
  )
end

unless Format.find_by_name('Dev Talk')
  Format.create!(
   name: 'Dev Talk'
  )
end

p "End format seeds"