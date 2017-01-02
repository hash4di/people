require 'spec_helper'

describe Api::V2::UserSkillRatesSerializer do
  subject { described_class.new(user).serializable_hash }
  let!(:user) { create(:user) }
  let!(:skill) { create :skill }
  let!(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill, rate: 3) }
  let!(:user_skill_rate2) { create(:user_skill_rate, user: user, skill: skill) }

  context 'returns user skill rates hash' do
    it 'returns correct hash', :aggregate_failures do
      expect(subject[:user_with_skill_rates].keys).to include(user.email)
      expect(subject[:user_with_skill_rates][user.email].length).to eq(2)
      expect(subject[:user_with_skill_rates][user.email].last[:rate]).to eq(0)
    end
  end
end
