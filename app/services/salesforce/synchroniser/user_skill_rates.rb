module Salesforce
  module Synchroniser
    class UserSkillRates
      BATCH_SIZE = 5000

      def upsert(skill_ids:, user_ids:)
        job = create_job('upsert')
        user_skill_rates(user_ids, skill_ids).find_in_batches(batch_size: BATCH_SIZE) do |rates_group|
          bulk_client.add_batch job["id"], serialized(rates_group)
        end

        close job
      end

      def mass_delete!
        job = create_job('delete')
        entries = restforce_client.query("select id from SkillRating__c").entries

        entries.each_slice(BATCH_SIZE) do |batch|
          json_batch = batch.map { |r| r.slice("id") }.to_json
          bulk_client.add_batch job["id"], json_batch
        end
        binding.pry
        close job
      end

      private

      def close(job)
        bulk_client.close_job(job['id'])
      end

      def serialized(usr)
        ActiveModel::ArraySerializer.new(
          usr, each_serializer: Salesforce::UserSkillRateSerializer
        ).to_json
      end

      def user_skill_rates(user_ids, skill_ids)
        @user_skill_rates ||= UserSkillRate
          .includes(:user, :skill)
          .where(user_id: user_ids, skill_id: skill_ids)
      end

      def bulk_client
        @client ||= Salesforce::BulkClient.new
      end

      def restforce_client
        @rclient ||= Restforce.new
      end

      def create_job(operation)
        bulk_client.create_job(
          external_id_field_name: UserSkillRate::SALESFORCE.fetch(:external_id),
          sf_object: UserSkillRate::SALESFORCE.fetch(:object),
          operation: operation
        )["jobInfo"]
      end
    end
  end
end
