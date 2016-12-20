require 'spec_helper'

describe UserSkillRate::Content do
  describe 'validations' do
    it { is_expected.to  validate_presence_of :rate }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:user_id).to(:user_skill_rate) }
    it { is_expected.to delegate_method(:skill_id).to(:user_skill_rate) }
  end

  subject { build :user_skill_rate_content }

  describe '#rate' do
    subject { described_class.new }
    it 'equals 0 by default' do
      expect(subject.rate).to eq 0
    end
  end
end
