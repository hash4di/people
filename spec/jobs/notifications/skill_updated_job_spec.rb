require 'spec_helper'

describe Notifications::SkillUpdatedJob do
  subject { described_class.perform_async(skill_id: skill.id) }

  let(:skill) { create(:skill) }

  describe '#perform' do
    let(:generator) do
      instance_double('Notifications::Skill::Updated', notify: true)
    end

    before do
      allow(
        Notifications::Skill::Updated
      ).to receive(:new).with(
        notifiable_id: skill.id
      ).and_return(generator)
      allow(generator).to receive(:notify).and_return(true)
    end

    it 'executes service for sending skill updated notifications' do
      expect(
        Notifications::Skill::Updated
      ).to receive(:new).with(
        notifiable_id: skill.id
      ).and_return(generator)
      expect(generator).to receive(:notify).and_return(true)
      subject
    end
  end
end
