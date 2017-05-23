module Users
  class UserSyncError
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def not_found
      @msg = "Couldn't find User id: #{user.id}, name: #{user.first_name} " \
              "#{user.last_name}, email: #{user.email}."
      @solution = "Check if User's first name, last name and email are exact in PeopleApp and Salesforce. " \
                 "If User exists and have correct attributes then try to clear Apiguru's and People's cache."
      self
    end
  end
end
