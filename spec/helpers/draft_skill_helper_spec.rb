require 'spec_helper'

describe DraftSkillHelper do
  describe '#update_request_btn_class' do
    subject { helper.update_request_btn_class(draft_skill, user) }

    let(:user) { create(:user) }

    context 'when user is requester' do
      let(:draft_skill) { create(:draft_skill, requester: user) }
      it { expect(subject).to eq 'disabled' }
    end

    context 'when user is not requester' do
      let(:draft_skill) { create(:draft_skill) }
      it { expect(subject).to eq nil }
    end
  end
end
