require 'spec_helper'

describe ::UserSkillRate::RateWithinRangeValidator do
  describe 'ensures proper range' do
    context 'when within range' do
      let(:content) { build(:user_skill_rate_content, :with_boolean_rate_type, rate: 1) }

      it 'pass validation' do
        described_class.new.validate(content)

        result = content.errors.count
        expect(result).to eq(0)
      end
    end

    context 'when out of range' do
      let(:content) { build(:user_skill_rate_content, :with_boolean_rate_type, rate: 99) }

      it 'fails validation' do
        described_class.new.validate(content)

        result = content.errors.full_messages
        expect(result).to include('Skill is not included in the list')
      end
    end
  end
end
