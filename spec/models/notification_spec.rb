require 'spec_helper'

describe Notification do
  describe 'validations' do
    let(:expected_STATUSES) { %w(notified unread) }
    let(:expected_TYPES) { expected_SKILL_TYPES }
    let(:expected_SKILL_TYPES) { %w(skill_updated skill_created) }

    it { is_expected.to belong_to :notifiable }
    it { is_expected.to belong_to :receiver }

    it { is_expected.to validate_inclusion_of(:notification_type).in_array(expected_TYPES) }
    it { is_expected.to validate_inclusion_of(:notification_status).in_array(expected_STATUSES) }
  end

  describe '#skill?' do
    subject { notification.skill? }

    let(:notification) { build(:notification) }
    it { expect(subject).to eq true }
  end

  describe '#notified?' do
    subject { notification.notified? }

    context 'when notificaiton status equals unread' do
      let(:notification) { build(:notification, :unread) }
      it { expect(subject).to eq false }
    end

    context 'when notificaiton status equals notified' do
      let(:notification) { build(:notification, :notified) }
      it { expect(subject).to eq true }
    end
  end

  describe '#skill_created?' do
    subject { notification.skill_created? }

    context 'when notificaiton type equals skill_updated' do
      let(:notification) { build(:notification, :skill_updated) }
      it { expect(subject).to eq false }
    end

    context 'when notificaiton type equals skill_created' do
      let(:notification) { build(:notification, :skill_created) }
      it { expect(subject).to eq true }
    end
  end

  describe '#skill_updated?' do
    subject { notification.skill_updated? }

    context 'when notificaiton type equals skill_created' do
      let(:notification) { build(:notification, :skill_created) }
      it { expect(subject).to eq false }
    end

    context 'when notificaiton type equals skill_updated' do
      let(:notification) { build(:notification, :skill_updated) }
      it { expect(subject).to eq true }
    end
  end
end
