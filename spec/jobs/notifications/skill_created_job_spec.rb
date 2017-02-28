require 'spec_helper'

describe Notifications::SkillCreatedJob do
  subject { described_class.perform_async(draft_skill_id: expected_dtaft_skill_id) }

  let(:skill) { create(:skill, :with_awaiting_create_request) }
  let(:expected_dtaft_skill_id) { skill.draft_skills.last.id }

  describe '#perform' do
    let(:generator) do
      instance_double('Notifications::Skill::Created', notify: true)
    end

    before do
      allow(
        Notifications::Skill::Created
      ).to receive(:new).with(
        notifiable_id: expected_dtaft_skill_id
      ).and_return(generator)
      allow(generator).to receive(:notify).and_return(true)
    end

    it 'executes service for sending skill created notifications' do
      expect(
        Notifications::Skill::Created
      ).to receive(:new).with(
        notifiable_id: expected_dtaft_skill_id
      ).and_return(generator)
      expect(generator).to receive(:notify).and_return(true)
      subject
    end
  end
end
