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
end
