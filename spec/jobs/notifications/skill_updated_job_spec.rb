require 'spec_helper'

describe Notifications::SkillUpdatedJob do
  subject { described_class.perform_async(draft_skill_id: expected_draft_skill_id) }

  let(:skill) { create(:skill, :with_awaiting_change_request) }
  let(:expected_draft_skill_id) { skill.requested_change.id }

  describe '#perform' do
    let(:generator) do
      instance_double('Notifications::Skill::Updated', notify: true)
    end

    before do
      allow(
        Notifications::Skill::Updated
      ).to receive(:new).with(
        notifiable_id: expected_draft_skill_id
      ).and_return(generator)
      allow(generator).to receive(:notify).and_return(true)
    end

    it 'executes service for sending skill updated notifications' do
      expect(
        Notifications::Skill::Updated
      ).to receive(:new).with(
        notifiable_id: expected_draft_skill_id
      ).and_return(generator)
      expect(generator).to receive(:notify).and_return(true)
      subject
    end
  end
end
