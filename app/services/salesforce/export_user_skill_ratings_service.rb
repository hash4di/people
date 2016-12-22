module Salesforce
  ExportFailed = Class.new(StandardError)

  class ExportUserSkillRatingsService
    def call
      UserSkillRate.find_each do |rating|
        repository.sync(rating)
        Rails.logger.info("UserSkillRating(id=#{ rating.id }) exported to Salesforce")
      end
    end

    def repository
      @repository ||= Salesforce::UserSkillRatingsRepository.new(Restforce.new)
    end
  end
end
