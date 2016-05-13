require 'spec_helper'

describe Projects::EndCurrentMemberships do
  let(:memberships) { [create(:membership, :without_end), create(:membership)] }
  let(:project) { create(:project, memberships: memberships) }
  subject { described_class.new(project) }
  let(:time) { Date.current.end_of_day }

  before do
    subject.call
  end

  describe '#call' do
    it 'sets ends_at for associated memberships' do
      aggregate_failures do
        memberships.each do |membership|
          expect(membership.reload.ends_at.to_i).to eq time.to_i
        end
      end
    end
  end
end
