require 'spec_helper'

describe UserSkillRatesFetcher do
  subject { described_class.new(user.id) }
  let!(:user) { create(:user) }
  let!(:skill) { create :skill }
  let!(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill, rate: 3) }
  let!(:user_skill_rate2) { create(:user_skill_rate, user: user, skill: skill) }

  context 'returns user skill rates hash' do
    it 'returns correct hash', :aggregate_failures do
      expect(subject.call.keys).to include(user.email)
      expect(subject.call[user.email].length).to eq(2)
    end
  end
end
