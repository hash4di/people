require 'spec_helper'

describe ::Skills::UserSkillRates::Update do
  let(:content) { create(:user_skill_rate_content, :with_boolean_rate_type, rate: 0) }
  subject { described_class.new(user_id: content.user_id, skill_id: content.skill_id, rate: 1) }

  describe '#call' do
    it 'keeps version of old content, and creates new one' do
      subject.call

      expect(::UserSkillRate::Content.count).to eq(2)
      expect(::UserSkillRate::Content.first.rate).to eq(0)
      expect(::UserSkillRate::Content.second.rate).to eq(1)
    end
  end
end
