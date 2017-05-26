module Salesforce::Synchroniser
  BATCH_SIZE = 5000

  class Base
    private

    def bulk_client
      @bulk_client ||= Salesforce::BulkClient.new
    end

    def restforce_client
      @rest_client ||= Restforce.new
    end

    def create_job(operation, klass)
      bulk_client.create_job(
        external_id_field_name: klass::SALESFORCE.fetch(:external_id),
        sf_object: klass::SALESFORCE.fetch(:object),
        operation: operation
      )["jobInfo"]
    end

    def close_job(job)
      bulk_client.close_job(job['id'])
    end
  end
end
