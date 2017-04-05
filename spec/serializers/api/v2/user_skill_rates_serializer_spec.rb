require 'spec_helper'

describe Api::V2::UserSkillRatesSerializer do
  subject { described_class.new(user_skill_rate1).serializable_hash }
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }
  let(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill, rate: 3) }
  let(:expected_hash) do
    {
      ref_name: user_skill_rate1.skill.ref_name,
      rate: user_skill_rate1.rate,
      email: user_skill_rate1.user.email
    }
  end

  before do
    allow(user_skill_rate1).to receive(:ref_name).and_return(user_skill_rate1.skill.ref_name)
    allow(user_skill_rate1).to receive(:email).and_return(user_skill_rate1.user.email)
  end

  context 'returns user skill rates hash' do
    it 'returns correct hash', :aggregate_failures do
      expect(subject).to be_a(Hash)
      expect(subject).to eq(expected_hash)
    end
  end
end
