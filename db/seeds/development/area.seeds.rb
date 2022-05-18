return if Area.count > 0

Area.create(
  name: "Art",
  sort_order: 1
)

Area.create(
  name: "Events",
  sort_order: 2
)

Area.create(
  name: "Literature",
  sort_order: 3
)
