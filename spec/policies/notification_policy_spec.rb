require 'spec_helper'

describe NotificationPolicy do
  subject { described_class.new(current_user, notification) }
  let(:current_user) { create(:user) }
  let(:notification) { create(:notification) }

  describe '#update?' do
    context 'when user is receiver' do
      let(:notification) { create(:notification, receiver: current_user) }
      it { expect(subject.update?).to be true }
    end

    context 'when user is not receiver' do
      it { expect(subject.update?).to be false }
    end
  end

  describe '#update?' do
    context 'when user is receiver' do
      let(:notification) { create(:notification, receiver: current_user) }
      it { expect(subject.show?).to be true }
    end

    context 'when user is not receiver' do
      it { expect(subject.show?).to be false }
    end
  end
end
