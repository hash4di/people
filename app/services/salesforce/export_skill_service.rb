module Salesforce
  ExportFailed = Class.new(StandardError)

  class ExportSkillService
    def call(skill_id)
      skill = Skill.find(skill_id)
      repository.sync(skill)
      Rails.logger.info("Skill(name=#{ skill.name }) exported to Salesforce")
    end

    def repository
      @repository ||= Salesforce::SkillsRepository.new(Restforce.new)
    end
  end
end
