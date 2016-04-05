require 'spec_helper'

describe MembershipsRepository do
  describe '.upcoming_changes' do
    let(:days) { 14 }
    let!(:membership1) { create(:membership, starts_at: 1.week.from_now) }
    let!(:membership2) { create(:membership, starts_at: 1.week.from_now) }
    let!(:future_membership) do
      create(
        :membership,
        starts_at: 15.days.from_now,
        ends_at: nil
      )
    end

    subject { described_class.new.upcoming_changes(days).to_a.flatten }

    it 'includes 2 upcoming changes' do
      expect(subject).to include membership1, membership2
    end

    it 'does not include other memberships' do
      expect(subject).not_to include future_membership
    end
  end
end
