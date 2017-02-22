module Salesforce
  ExportFailed = Class.new(StandardError)

  class ExportSkillsService
    def call
      Skill.find_each do |skill|
        repository.sync(skill)
        Rails.logger.info("Skill(name=#{skill.name} exported to Salesforce")
      end
    end

    def repository
      @repository ||= Salesforce::SkillsRepository.new(Restforce.new)
    end
  end
end
