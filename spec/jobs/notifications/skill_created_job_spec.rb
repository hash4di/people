require 'spec_helper'

describe Notifications::SkillCreatedJob do
  subject { described_class.perform_async(skill_id: skill.id) }

  let(:skill) { create(:skill) }

  describe '#perform' do
    let(:generator) do
      instance_double('Notifications::Skill::Created', notify: true)
    end

    before do
      allow(
        Notifications::Skill::Created
      ).to receive(:new).with(
        notifiable_id: skill.id
      ).and_return(generator)
      allow(generator).to receive(:notify).and_return(true)
    end

    it 'executes service for sending skill created notifications' do
      expect(
        Notifications::Skill::Created
      ).to receive(:new).with(
        notifiable_id: skill.id
      ).and_return(generator)
      expect(generator).to receive(:notify).and_return(true)
      subject
    end
  end
end
