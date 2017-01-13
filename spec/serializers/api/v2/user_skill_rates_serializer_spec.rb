require 'spec_helper'

describe Api::V2::UserSkillRatesSerializer do
  subject { described_class.new(user_skill_rate1).serializable_hash }
  let!(:user) { create(:user) }
  let!(:skill) { create(:skill) }
  let!(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill, rate: 3) }

  context 'returns user skill rates hash' do
    it 'returns correct hash', :aggregate_failures do
      expect(subject).to be_a(Hash)
      expect(subject)
        .to eq(
          { ref_name: skill.ref_name.to_s, rate: user_skill_rate1.rate }
        )
    end
  end
end
