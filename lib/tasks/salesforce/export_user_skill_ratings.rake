namespace :salesforce do
  desc "Export user skill ratings from the database to salesforce"
  task export_user_skill_ratings: :environment do
    Salesforce::ExportUserSkillRatingsService.new.call
  end
end
