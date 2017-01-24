require 'csv'

namespace :skills do
  desc 'Generate seeds based on .csv file'
  task generate_seeds: :environment do
    root_dir = Dir.pwd
    file = File.join(root_dir, 'skills.csv')

    skills = []
    CSV.foreach(file, headers: true) do |row|
      ref_name = (row['category'] + '_' + row['name']).parameterize

      skills << {
        ref_name: ref_name,
        name: row['name'],
        rating: row['rating'],
        description: row['description'],
        category: row['category'],
      }
    end

    file = File.join(root_dir, 'db', 'seeds', 'data', 'skills_and_categories.rb')
    File.open(file, 'w+') do |f|
      f.puts('SKILLS_AND_CATEGORIES = [')

      skills.each { |element| f.puts(element.to_s + ',') }

      f.puts(']')
    end
  end

  desc 'Create skills from generated seeds'
  task generate_skills: :environment do
    Skills::GenerateFromSeeds.call
  end
end
