module Apiguru
  class Client
    class << self
      def client
        Rails.cache.fetch(url, expires_in: 12.hours) do
          response = HTTParty.get(url, query: { token: token })
          JSON.parse(response.body, symbolize_names: true)
        end
      end

      private

      def url
        AppConfig.apiguru.url
      end

      def token
        AppConfig.apiguru.token
      end
    end
  end
end
