require 'spec_helper'

describe CreateRatesForUserJob do
  subject { described_class.perform_async(user_id: user.id) }

  let(:user) { create(:user) }

  describe '#perform' do
    let(:generator) do
      instance_double('Skills::UserSkillRatesGenerator', generate_all_for_user: true)
    end

    before do
      allow(
        Skills::UserSkillRatesGenerator
      ).to receive(:new).and_return(generator)
      allow(generator).to receive(:generate_all_for_user).with(
        user_id: user.id
      ).and_return(true)
    end

    it 'executes service for genearting user skill rates' do
      expect(
        Skills::UserSkillRatesGenerator
      ).to receive(:new).and_return(generator)
      expect(generator).to receive(:generate_all_for_user).with(
        user_id: user.id
      ).and_return(true)
      subject
    end
  end
end
