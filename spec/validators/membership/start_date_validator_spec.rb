require 'spec_helper'

describe Membership::StartDateValidator do
  context 'record is valid' do
    let(:record) { build(:membership) }
    it 'does not raise errors' do
      described_class.new.validate(record)
      expect(record.errors).to be_empty
    end
  end

  context 'record is invalid' do
    let(:project) { build(:project, starts_at: 5.days.ago, end_at: Date.current) }
    let(:record) { build(:membership, project: project, starts_at: 3.days.from_now, ends_at: nil) }
    it 'raises errors' do
      described_class.new.validate(record)
      expect(record.errors).to_not be_empty
    end
  end
end
