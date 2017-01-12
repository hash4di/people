require 'spec_helper'

describe Api::V2::UserSkillRatesSerializer do
  subject { described_class.new(user).serializable_hash }
  let!(:user) { create(:user) }
  let!(:skill) { create :skill }
  let!(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill, rate: 3) }
  let!(:user_skill_rate2) { create(:user_skill_rate, user: user, skill: skill) }

  context 'returns user skill rates hash' do
    it 'returns correct hash', :aggregate_failures do
      expect(subject[:skill_rates]).to be_a(Array)
      expect(subject[:skill_rates].size).to eq(2)
    end
  end
end
