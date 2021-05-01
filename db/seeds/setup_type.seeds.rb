#setup_type

SetupType.delete_all

SetupType.create(
    name: "Theater",
    description: "Set up room theater style with chairs in rows facing tables at head of room."
)
SetupType.create(
    name: "Open Room",
    description: "Set up room with nothing in it."
)
SetupType.create(
    name: "Chair Cirle",
    description: "Set up room with chairs in a circle facing inward."
)
SetupType.create(
    name: "Other",
    description: "Other"
)

p "Created #{SetupType.count} room setup types."