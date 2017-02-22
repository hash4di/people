module Salesforce
  ExportFailed = Class.new(StandardError)

  class ExportUsersService
    def call
      User.find_each do |user|
        repository.sync(user)
        Rails.logger.info("User(email=#{user.email} exported to salesforce)")
      end
    end

    def repository
      @repository ||= Salesforce::UsersRepository.new(Restforce.new)
    end
  end
end
