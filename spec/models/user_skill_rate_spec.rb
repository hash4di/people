require 'spec_helper'

describe UserSkillRate do
  describe 'associations' do
    it { is_expected.to belong_to :skill }
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    let(:user_skill_rate) { create(:user_skill_rate) }

    it { is_expected.to validate_presence_of :skill }
    it { is_expected.to validate_presence_of :user }

    # there is a problem inside shoulda gem, check this issue on GH: https://github.com/thoughtbot/shoulda-matchers/issues/535
    it 'enforces uniqueness' do
      expect(
        user_skill_rate
      ).to validate_uniqueness_of(:skill).scoped_to(:user_id)
    end
  end

  describe '#content' do
    let(:user_skill_rate) { create(:user_skill_rate) }
    let!(:user_skill_rate_content_1) do
      create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 1)
    end
    let!(:user_skill_rate_content_2) do
      create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 2)
    end
    let!(:newest_user_skill_rate_content) do
      create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 0)
    end

    it 'returns newest content' do
      expect(user_skill_rate.content).to eq(newest_user_skill_rate_content)
    end
  end

  context 'when destroyed' do
    let!(:user_skill_rate) do
      FactoryGirl.create(:user_skill_rate, :with_content)
    end

    subject { user_skill_rate.destroy }

    context 'has been successfully deleted from salesforce' do
      before { allow(user_skill_rate).to receive(:delete_from_sf!) { true } }

      it 'destroys associated Contents' do
        expect { subject }.to change { UserSkillRate::Content.count }.from(1).to(0)
      end
    end

    context 'has not been successfully deleted from salesforce' do
      before { allow(user_skill_rate).to receive(:delete_from_sf!) { false } }

      it 'does not destroy associated Contents' do
        expect { subject }.to_not change { UserSkillRate::Content.count }
      end
    end
  end
end
