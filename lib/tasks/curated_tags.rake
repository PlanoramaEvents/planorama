
namespace :curated_tags do
  # The G24 lists of labels and tags
  LABELS = [
    'A&S - In Progress',
    'A&S - Ready for Scheduling',
    'A&S - Reserve',
    'CR - Do Not Change Assignments',
    'CR - Do Not Change Room',
    'CR - Do Not Reschedule',
    'Cross-Area',
    'Duplicate - Do Not Use',
    'Hugo - Designed for Finalists',
    'Hugo - Finalist Assigned',
    'Guest - Possible for Anita Sengupta',
    'Guest - Possible for Barbara Hambly',
    'Guest - Possible for Colleen Doran',
    'Guest - Possible for Geri Sullivan',
    'Guest - Possible for Ronald D Moore',
    'Guest - Possible for Stan Sakai',
    'Guest - Possible for Tim Kirk',
    'Guest - Possible for Tracy Drain',
    'Guest - Possible for Ursula Vernon',
    'ProgDev - Could Have',
    'ProgDev - Dropped',
    'ProgDev - Must Have',
    'ProgDev - Should Have',
    'Review - Editorial Complete',
    'Review - Editorial in Progress',
    'Review - Sensitivity in Progress',
    'Review - Ready for Editorial',
    'Review - Ready for Sensitivity',
    'Review - Sensitivity Complete',
    'Selection - Do Not Open for Interest',
    'Selection - Ready to Open for Interest',
    'Selection - Was Open for Interest',
    'Guest - Possible for Terese Mason Pierre',
    'Guest - Possible for Tracey Baptiste',
    'Review - Editorial Revision Needed',
    'Review - Sensitivity Revision Needed'
  ]

  TAGS = [
    'AI',
    'Amusement',
    'Astronomy and Space',
    'Bioscience',
    'Chemistry',
    'Computer Science',
    'Contracts',
    'Conventions',
    'Crafting',
    'Editing',
    'Engineering',
    'Erotica',
    'Fandom History',
    'Fantasy',
    'Guest of Honor',
    'History',
    'Horror',
    'How To',
    'Identity',
    'Inclusivity',
    'Legends, Folklore and Fairytales',
    'Mathematics',
    'Physics',
    'Poetry',
    'Politics',
    '1946 Project',
    'Publishing',
    'Roleplaying',
    'Romance',
    'Science and Society',
    'Science Fiction',
    'Special Guest',
    'Sustainability',
    'Tabletop Games',
    'Fanfic and Transformative Works',
    'Video Games',
    'Worldbuilding',
    'Writing',
    'Stagecraft',
    'Performing Arts',
    'Español',
    'SoCal',
    'Exercise'
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
