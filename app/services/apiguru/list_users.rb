module Apiguru
  class ListUsers
    def call
      storage
    end

    private

    def storage
      Apiguru::Client.client(url)
    end

    def url
      AppConfig.apiguru.users_url
    end
  end
end
