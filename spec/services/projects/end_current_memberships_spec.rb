require 'spec_helper'

describe Projects::EndCurrentMemberships do
  let(:memberships) { [create(:membership, :without_end), create(:membership, :without_end)] }
  let(:project) { create(:project, memberships: memberships) }
  subject { described_class.new(project) }

  before do
    subject.call
  end

  describe '#call' do
    it 'sets' do
      aggregate_failures do
        memberships.each do |membership|
          expect(membership.reload.ends_at).to_not be nil
        end
      end
    end
  end
end
