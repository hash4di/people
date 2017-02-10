require 'spec_helper'

describe DraftSkillPolicy do
  subject { described_class.new(current_user, draft_skill) }
  let(:current_user) { create(:user) }
  let(:draft_skill) { create(:draft_skill, :with_created_draft_status) }

  describe '#allowed_to_modifie?' do
    context 'when user is requester' do
      let(:draft_skill) do
        create(:draft_skill, :with_created_draft_status, requester: current_user)
      end
      it { expect(subject.allowed_to_modifie?).to be false }
    end

    context 'when user is not requester' do
      it { expect(subject.allowed_to_modifie?).to be true }
    end
  end
end
