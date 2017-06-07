namespace :salesforce do
  desc 'Export skills from the database to salesforce'
  task export_skills: :environment do
    Salesforce::ExportSkillsService.new.call
  end
end
