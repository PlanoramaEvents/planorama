
namespace :curated_tags do
  desc ""
  task labels: :environment do
    names = ['ready for review', 'ready for scheduling', 'cross-cutting', 'do not move']
    names.each do |name|
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
    names = [
      'science fiction', 'fantasy', 'romance', 'erotica', 'worldbuilding', 'literature', '101',
      'astronomy','bioscience','chemistry','computer science','engineering','mathematics','physics'
    ]
    names.each do |name|
      tag = CuratedTag.find_by name: name, context: 'tag'
      next if tag

      CuratedTag.create({
        name: name,
        context: 'tag'
      })
    end
  end
end
