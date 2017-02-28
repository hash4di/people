require 'spec_helper'

describe CreateRatesForSkillJob do
  subject { described_class.perform_async(skill_id: skill.id) }

  let(:skill) { create(:skill) }

  describe '#perform' do
    let(:generator) do
      instance_double(
        'Skills::UserSkillRatesGenerator', generate_single_for_all_users: true
      )
    end

    before do
      allow(
        Skills::UserSkillRatesGenerator
      ).to receive(:new).and_return(generator)
      allow(generator).to receive(:generate_single_for_all_users).with(
        skill_id: skill.id
      ).and_return(true)
    end

    it 'executes service for genearting user skill rates' do
      expect(
        Skills::UserSkillRatesGenerator
      ).to receive(:new).and_return(generator)
      expect(generator).to receive(:generate_single_for_all_users).with(
        skill_id: skill.id
      ).and_return(true)
      subject
    end
  end
end
