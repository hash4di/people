require 'spec_helper'

describe SkillHelper do
  describe '#request_change_btn_class' do
    subject { helper.request_change_btn_class(skill) }

    context 'when requested change exists' do
      let(:skill) { create(:skill, :with_awaiting_change_request) }
      it { expect(subject).to eq 'disabled' }
    end

    context 'when requested change does not exist' do
      let(:skill) { create(:skill) }
      it { expect(subject).to eq nil }
    end
  end
end
