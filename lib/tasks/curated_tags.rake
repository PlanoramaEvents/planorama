
namespace :curated_tags do
  # The G24 lists of labels and tags
  LABELS = [
    'Cross-Area',
    'Duplicate - Do Not Use',
    'Definite Possibility',
    'Possibility',
    'Ready for Review',
    'Ready for Diversity Review',
    'In Review',
    'Ready for Scheduling',
    'Do Not Change Room',
    'Do Not Reschedule',
    'Do Not Change Assignments',
    'Chris Baker (Fangorn)',
    'Claire Brialey and Mark Plummer',
    'Ken MacLeod',
    'Nnedi Okorafor',
    'Terri Windling',
    'Tanya DePass',
    'Catherine Heymans',
    'Tendai Huchu',
    '3 Black Halflings',
    'Hugo Finalist',
    'Reserve',
    'Assignment in Progress',
    'Assignment Complete'
  ]

  TAGS = [
    "Agents",
    "AI",
    "Astronomy",
    "Bioscience",
    "Chemistry",
    "Climate Change",
    "Computer Science",
    "Conrunning",
    "Contracts",
    "Crafting",
    "Editing",
    "Engineering",
    "Erotica",
    "Fantasy",
    "Guest of Honour",
    "History",
    "Horror",
    "Mathematics",
    "Physics",
    "Post-War SF and Fandom",
    "Publishing",
    "Roleplaying",
    "Romance",
    "Science and Society",
    "Science Fiction",
    "Scotland",
    "Special Guest",
    "Video Games",
    "Worldbuilding",
    "Writing",
    "Our Future in Space",
    "Our Future on Earth",
    "Our Future Selves"
  ]

  desc ""
  task labels: :environment do
    LABELS.each do |name|
      tag = CuratedTag.find_by name: name, context: 'label'
      next if tag

      CuratedTag.create({
        name: name,
        context: 'label'
      })
    end
  end

  desc ""
  task tags: :environment do
    TAGS.each do |name|
      tag = CuratedTag.find_by name: name, context: 'tag'
      next if tag

      CuratedTag.create({
        name: name,
        context: 'tag'
      })
    end
  end

  # A brute force mechanism to update DB tags with the correct case...
  desc ""
  task fix_case: :environment do
    TAGS.each do |name|
      fix_tag(name: name, context: 'tag')
    end
    LABELS.each do |name|
      fix_tag(name: name, context: 'label')
    end
  end

  def fix_tag(name:, context:)
    ctag = CuratedTag.where("name ILIKE ? and context = ?", name, context).first
    if ctag
      ctag.name = name
      ctag.save

      tag = ActsAsTaggableOn::Tag.where("name ILIKE ?", name).first
      if tag
        tag.name = name
        tag.save
      end
    end
  end
end
