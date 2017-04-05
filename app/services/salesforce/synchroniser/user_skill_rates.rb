module Salesforce::Synchroniser
  class UserSkillRates < Salesforce::Synchroniser::Base
    def upsert(skill_ids:, user_ids:)
      job = create_job('upsert', UserSkillRate)

      user_skill_rates(user_ids, skill_ids).find_in_batches(batch_size: BATCH_SIZE) do |rates_group|
        binding.pry
        bulk_client.add_batch job["id"], serialized(rates_group)
      end

      close_job job
    end

    def mass_delete!
      entries = restforce_client.query("select id from SkillRating__c").entries
      return if entries.blank?

      job = create_job('delete', UserSkillRate)

      entries.each_slice(BATCH_SIZE) do |batch|
        json_batch = batch.map { |r| r.slice("Id") }.to_json
        bulk_client.add_batch job["id"], json_batch
      end

      close_job job
    end

    def mass_upsert!
      upsert(
        user_ids: User.active.pluck(:id),
        skill_ids: Skill.pluck(:id)
      )
    end

    private

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
  end
end
