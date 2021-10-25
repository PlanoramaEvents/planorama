# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# require Rails.root.join("db/seeds/#{Rails.env}/.seeds.rb")

['all', '.', Rails.env].each do |seed|

  seed_file = Rails.root.join('db', 'seeds', "#{seed}.rb")
  if File.exists?(seed_file)
    puts "*** Loading #{seed} seed data"
    require seed_file
  end

  seed_dir = Rails.root.join('db', 'seeds', seed)
  if File.directory?(seed_dir)
    Dir[File.join(seed_dir, "*.rb")].each do |file|
      puts "*** Loading #{seed} seed data from #{file}"
      require file
    end
  end

end
