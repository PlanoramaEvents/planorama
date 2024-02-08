
namespace :curated_tags do
  desc ""
  task labels: :environment do
    names = ['Ready for review', 'Ready for scheduling', 'Cross-cutting', 'Do not move']
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
      'Science Fiction', 'Fantasy', 'Romance', 'Erotica', 'Worldbuilding', 'Literature', '101',
      'Astronomy','Bioscience','Chemistry','Computer Science','Engineering','Mathematics','Physics'
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