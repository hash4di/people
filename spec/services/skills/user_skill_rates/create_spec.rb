require 'spec_helper'

describe ::Skills::UserSkillRates::Create do
  subject { described_class.new(user_id: user.id, skill_id: skill.id, rate: 1) }
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }

  describe '#call' do
    it 'creates UserSkillRate with Content' do
      result = subject.call

      aggregate_failures do
        expect(result.user).to eq(user)
        expect(result.skill).to eq(skill)
        expect(result.rate).to eq(1)
      end
    end
  end
end
