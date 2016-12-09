require 'spec_helper'

describe UserSkillRate do
  it { is_expected.to belong_to :skill }
  it { is_expected.to belong_to :user }

  it { is_expected.to  validate_presence_of :skill }
  it { is_expected.to  validate_presence_of :user }
  it { is_expected.to  validate_presence_of :rate }

  subject { build :user_skill_rate }

  describe '#rate' do
    subject { described_class.new }
    it 'equals 0 by default' do
      expect(subject.rate).to eq 0
    end
  end
end
