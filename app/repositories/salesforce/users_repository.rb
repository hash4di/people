module Salesforce
  class UsersRepository < GenericRepository
    NETGURU_ACCOUNT_ID = '0017E00000WQJhJQAX'.freeze
    def salesforce_object_name
      'Contact'
    end

    def map_to_salesforce(user)
      {
        AccountId: NETGURU_ACCOUNT_ID,
        FirstName: user.first_name,
        LastName: user.last_name
      }
    end
  end
end
