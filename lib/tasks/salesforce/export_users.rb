namespace :salesforce
  desc 'Export users from the database to salesforce'
  task export_users: :environment do
    Salesforce::ExportUsersService.new.call
  end
end
