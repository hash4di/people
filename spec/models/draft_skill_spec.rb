require 'spec_helper'

describe DraftSkill do
  describe 'validations' do
    let(:expected_STATUSES) { %w(created accepted declined) }
    let(:expected_TYPES) { %w(update create) }

    it { is_expected.to belong_to :skill }
    it { is_expected.to belong_to :skill_category }
    it { is_expected.to belong_to :requester }
    it { is_expected.to belong_to :reviewer }

    it { is_expected.to validate_inclusion_of(:draft_type).in_array(expected_TYPES) }
    it { is_expected.to validate_inclusion_of(:draft_status).in_array(expected_STATUSES) }

    context 'when update' do
      before { allow(subject).to receive(:new_record?).and_return(false) }
      it { is_expected.to validate_presence_of :reviewer_explanation }
    end

    context 'when create' do
      before { allow(subject).to receive(:new_record?).and_return(true) }
      it { is_expected.to validate_presence_of :requester_explanation }
    end
  end

  describe '#resolved?' do
    subject { draft_skill.resolved? }

    context 'when draft_status equals created' do
      let(:draft_skill) { build(:draft_skill, :with_created_draft_status) }
      it 'returns false' do
        expect(subject).to eq false
      end
    end
    context 'when draft_status has different value' do
      let(:draft_skill) { build(:draft_skill, :with_accepted_draft_status) }
      it 'returns true' do
        expect(subject).to eq true
      end
    end
  end

  describe '#accepted?' do
    subject { draft_skill.accepted? }

    context 'when draft_status equals create' do
      let(:draft_skill) { build(:draft_skill, :with_accepted_draft_status) }
      it 'returns true' do
        expect(subject).to eq true
      end
    end
    context 'when draft_status has different value' do
      let(:draft_skill) { build(:draft_skill, :with_declined_draft_status) }
      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end

  describe '#create_type?' do
    subject { draft_skill.create_type? }

    context 'when draft_type equals create' do
      let(:draft_skill) { build(:draft_skill, :with_create_draft_type) }
      it 'returns true' do
        expect(subject).to eq true
      end
    end
    context 'when draft_type equals update' do
      let(:draft_skill) { build(:draft_skill, :with_update_draft_type) }
      it 'returns false' do
        expect(subject).to eq false
      end
    end
  end
end
