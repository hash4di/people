require 'spec_helper'

describe UserSkillRate do
  describe 'associations' do
    it { is_expected.to belong_to :skill }
    it { is_expected.to belong_to :user }
  end

  describe 'validations' do
    it { is_expected.to  validate_presence_of :skill }
    it { is_expected.to  validate_presence_of :user }
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
end
