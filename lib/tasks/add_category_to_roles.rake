# rubocop:disable

namespace :roles do
  desc 'Add category to roles'
  task add_categories: :environment do
    RolesToSkillMigration.new.call
  end
end
