# rubocop:disable

namespace :roles do
  desc 'Add category to roles'
  task add_categories: :environment do
    @backend = SkillCategory.find_or_create_by(name: 'backend')
    @frontend = SkillCategory.find_or_create_by(name: 'frontend')
    @devops = SkillCategory.find_or_create_by(name: 'devops')
    @design = SkillCategory.find_or_create_by(name: 'design')
    @android = SkillCategory.find_or_create_by(name: 'android')
    @ios = SkillCategory.find_or_create_by(name: 'iOS')

    def associate_to_category(role)
      case role.name
      when /(iOS)/i
        puts "Added role - #{role.name} - to category: #{@ios.name}"
        @backend.roles << role
      when /(android)/i
        puts "Added role - #{role.name} - to category: #{@android.name}"
        @android.roles << role
      when /(devops)/i
        puts "Added role - #{role.name} - to category: #{@devops.name}"
        @devops.roles << role
      when /(RoR)/i
        puts "Added role - #{role.name} - to category: #{@backend.name}"
        @backend.roles << role
      when /(design)/i
        puts "Added role - #{role.name} - to category: #{@design.name}"
        @design.roles << role
      when /(frontend)/i
        puts "Added role - #{role.name} - to category: #{@frontend.name}"
        @frontend.roles << role
      else
        puts "Category not found for: #{role.name}"
      end
    end

    puts "\n ------------------------------------------- \n"
    Role.all.each { |role| associate_to_category(role) }
    puts "\n ------------------------------------------- \n"
  end
end
