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

    it 'returns newest content' do
      create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 1)
      create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 2)
      content = create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 0)

      result = user_skill_rate.content
      expect(result).to eq(content)
    end
  end

  describe '#rate' do
    let(:user_skill_rate) { create(:user_skill_rate) }

    it 'returns content#rate' do
      create(:user_skill_rate_content, user_skill_rate: user_skill_rate, rate: 1)

      result = user_skill_rate.rate
      expect(result).to eq(1)
    end
  end
end
