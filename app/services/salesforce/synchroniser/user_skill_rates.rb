module Salesforce
  module Synchroniser
    class UserSkillRates
      def sync(skill_ids:, user_ids:)
        user_skill_rates(user_ids, skill_ids).find_in_batches(batch_size: 5000) do |rates_group|
          client.add_batch job["id"], serialized(rates_group)
        end

        close_job
      end

      private

      def close_job
        client.close_job(job['id'])
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

      def client
        @client ||= Salesforce::BulkClient.new
      end

      def job
        @job ||= client.create_job(
          external_id_field_name: UserSkillRate::SALESFORCE.fetch(:external_id),
          sf_object: UserSkillRate::SALESFORCE.fetch(:object),
          operation: 'upsert'
        )["jobInfo"]
      end
    end
  end
end
