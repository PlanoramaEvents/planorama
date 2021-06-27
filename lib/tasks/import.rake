desc "Utilities for importing various database records for chicon"

require 'csv'

strip_converter = proc {|field| field ? field.strip : field}
CSV::Converters[:strip] = strip_converter

namespace :import do
  task :users, [:filename] => :environment do |t, args|
    if !args[:filename]
      p "You need to add the filename as an argument: rake import:users[/path/to/file]"
    end
    File.open(args[:filename]) do |file|
      parsed_output = CSV.read(file, headers: true, header_converters: :symbol, converters: :strip)
      count = 0
      parsed_output.each do |o|
        email = o[:email]
        if !email 
          puts "Skipping #{o} because there is no email."
          next
        end
        name = o[:name]
        if !name
          puts "Skipping #{o} because there is no name."
          next
        end
        name_sort_by = name;
        pseudonym = o[:pseudonym]
        pseudonym_sort_by = pseudonym;
        comment = "Imported from spreadsheet."
        # tokens = name_sort_by.split(' ')
        # if tokens.length > 1 
        #   name_sort_by = "#{tokens[1..-1].join(' ')}, #{tokens[0]}"
        # end
        # puts "Person name: #{name}"
        # puts "Person pseudonym: #{pseudonym}"
        # print "What string should we use to sort this person (default: #{sort_by})? "
        # raw_sort_by_input = STDIN.gets.strip
        # if raw_sort_by_input == "" 
        #   puts "Using the default #{sort_by}"
        # else 
        #   puts "Using #{raw_sort_by_input}"
        #   sort_by = raw_sort_by_input
        # end
        # puts "<Person email=#{email} name=#{name} pseudonym=#{pseudonym} namesort_by=#{sort_by}>"
        found_email = EmailAddress.find_by(email: email, isdefault: true)
        if !found_email
          # there is no person! Make a new one.
          person = Person.create(
            name: name, 
            name_sort_by: name_sort_by, 
            pseudonym: pseudonym, 
            pseudonym_sort_by: pseudonym_sort_by
          );
          email = EmailAddress.create(
              person: person,
              email: email,
              isdefault: true,
              is_valid: true
          );
          p person, email
          count += 1
        else
          p "There is already person with the email #{found_email.email}, skipping"
          next
        end
      end
      p "Imported #{count} users, skipped #{parsed_output.length - count}"
    end
  end
end
