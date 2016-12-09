require 'spec_helper'

describe ::UserSkillRate::RateWithinRangeValidator do
  describe 'ensures proper range' do
    context 'when within range' do
      let(:skill) { build(:skill, :with_boolean_rate_type) }
      let(:user_skill_rate) { build(:user_skill_rate, skill: skill, rate: 1) }

      it 'pass validation' do
        described_class.new.validate(user_skill_rate)

        result = user_skill_rate.errors.count
        expect(result).to eq(0)
      end
    end

    context 'when out of range' do
      let(:skill) { create(:skill, :with_boolean_rate_type) }
      let(:user_skill_rate) { build(:user_skill_rate, skill: skill, rate: 99) }

      it 'fails validation' do
        described_class.new.validate(user_skill_rate)

        result = user_skill_rate.errors.full_messages
        expect(result).to include('Skill is not included in the list')
      end
    end
  end
end
