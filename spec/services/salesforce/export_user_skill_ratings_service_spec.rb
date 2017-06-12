require 'spec_helper'

describe Salesforce::ExportUserSkillRatingsService do
  subject { described_class }

  before { allow_any_instance_of(Restforce::Data::Client).to receive(:create) { 'skill' } }

  describe '.all_rated' do
    let!(:user1) { create :user, salesforce_id: 'sfid1' }
    let!(:user2) { create :user, salesforce_id: 'sfid2', archived: true }
    let!(:user3) { create :user, salesforce_id: 'sfid3' }
    let!(:user_skill_rate1) { create :user_skill_rate, user: user1, rate: 1 }
    let!(:user_skill_rate2) { create :user_skill_rate, user: user2, rate: 1 }
    let!(:user_skill_rate3) { create :user_skill_rate, user: user3, rate: 0 }

    it 'Exports only rated skills of active users' do
      expect { described_class.new.all_rated }
        .to change { UserSkillRate.order(:id).pluck(:salesforce_id) }
        .from([nil, nil, nil]).to(['skill', nil, nil])
    end
  end

  describe '.one' do
    let!(:user) { create :user, salesforce_id: 'sfid1' }
    let!(:user_skill_rate) { create :user_skill_rate, user: user, rate: 1 }

    context 'When synced successfully' do
      it 'updates salesforce_id' do
        expect { described_class.new.one(user_skill_rate.id) }
          .to change { UserSkillRate.find(user_skill_rate.id).salesforce_id }
      end
    end
  end
end
