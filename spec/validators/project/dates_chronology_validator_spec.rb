require 'spec_helper'

describe Project::DatesChronologyValidator do
  context 'record is valid' do
    let(:record) { build(:project) }
    it 'does not raise errors' do
      described_class.new.validate(record)
      expect(record.errors).to be_empty
    end
  end

  context 'record is invalid' do
    let(:record) { build(:project, starts_at: Date.current, end_at: 2.days.ago) }
    it 'raises errors' do
      described_class.new.validate(record)
      expect(record.errors).to_not be_empty
    end
  end
end
