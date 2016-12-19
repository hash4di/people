require 'spec_helper'

describe ::Skills::UserSkillRates::Create do
  subject do
    described_class.new(
      user_id: user.id,
      skill_id: skill.id
    )
  end
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }

  describe '#call' do
    let(:user_skill_rates) { user.reload.user_skill_rates }

    it 'creates UserSkillRate' do
      expect{ subject.call }.to change{ user_skill_rates.count }
    end

    it 'creates UserSkillRate::Content' do
      subject.call
      expect(user.user_skill_rates.first.contents.count).to eq(1)
    end
  end
end
