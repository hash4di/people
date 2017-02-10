require 'spec_helper'

describe SkillPolicy do
  subject { described_class.new(current_user, skill) }
  let(:current_user) { create(:user, :admin) }
  let!(:skill) { create(:skill) }

  describe '#access_request_change?' do
    context 'when skill has requested change' do
      let(:skill) { create(:skill, :with_awaiting_change_request) }
      it { expect(subject.access_request_change?).to be false }
    end

    context 'when skill has not requested change' do
      it { expect(subject.access_request_change?).to be true }
    end
  end
end
