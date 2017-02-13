# rubocop:disable

class RolesToSkillMigration
  def initialize
    @backend = SkillCategory.find_or_create_by(name: 'backend')
    @frontend = SkillCategory.find_or_create_by(name: 'frontend')
    @devops = SkillCategory.find_or_create_by(name: 'devops')
    @design = SkillCategory.find_or_create_by(name: 'design')
    @android = SkillCategory.find_or_create_by(name: 'android')
    @ios = SkillCategory.find_or_create_by(name: 'iOS')
  end

  def call
    Role.find_each { |role| associate_to_skill_category(role) }
  end

  private

  def associate_to_skill_category(role)
    case role.name
    when /(ios)/i
      @ios.roles << role
    when /(android)/i
      @android.roles << role
    when /(devops)/i
      @devops.roles << role
    when /(ror)/i
      @backend.roles << role
    when /(design)/i
      @design.roles << role
    when /(frontend)/i
      @frontend.roles << role
    else
      Rails.logger.info "SKILLS MIGRATION: Category not found for: #{role.name}"
    end
  end
end
