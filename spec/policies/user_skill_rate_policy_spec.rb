require 'spec_helper'

describe UserSkillRatePolicy do
  subject { described_class.new(current_user, user_skill_rate) }
  let(:current_user) { create(:user) }
  let(:user_skill_rate) { create(:user_skill_rate) }

  describe '#update?' do
    context 'when user is owner' do
      let(:user_skill_rate) { create(:user_skill_rate, user: current_user) }
      it { expect(subject.update?).to be true }
    end

    context 'when user is not user' do
      it { expect(subject.update?).to be false }
    end
  end
end
