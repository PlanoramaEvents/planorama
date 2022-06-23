p "Start development room service seeds"

unless RoomService.find_by_name('Timy whiney time machine')
  RoomService.create!(
    name: 'Timy whiney time machine'
  )
end

unless RoomService.find_by_name('Tardis')
  RoomService.create!(
   name: 'Tardis'
  )
end

p "End room service seeds"
