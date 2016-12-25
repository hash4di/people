module Salesforce
  class UsersRepository < GenericRepository
    def salesforce_object_name
      'Developer__c'
    end

    def map_to_salesforce(user)
      {
        Name: [user.first_name, user.last_name].join(" "),
      }
    end
  end
end
