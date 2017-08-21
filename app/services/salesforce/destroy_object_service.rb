module Salesforce
  class DestroyObjectService
    def call(api_name, salesforce_id)
      return false if salesforce_id.nil?

      begin
        sf_object = sf_client.find(api_name, salesforce_id)
      rescue Faraday::ResourceNotFound
        return false
      end

      sf_object.destroy
    end

    def sf_client
      @sf_client ||= Restforce.new
    end
  end
end
