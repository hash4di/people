require 'spec_helper'

describe Memberships::UpdateBooked do
  let(:membership) { create(:membership, :booked) }
  subject { described_class.new(membership.id.to_s) } # frontend sends id as string

  describe '#call' do
    context 'booked is changed to false' do
      before do
        subject.call(false)
      end

      it 'sets booked to false' do
        expect(membership.reload.booked).to eq(false)
      end
    end
  end
end
