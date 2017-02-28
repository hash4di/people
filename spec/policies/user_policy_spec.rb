require 'spec_helper'

describe UserPolicy do
  subject { described_class.new(current_user, user_with_history) }
  let(:user_with_history) { create(:user) }

  describe '#history?' do
    context 'when it is user\'s history' do
      let(:current_user) { create(:user) }
      let(:user_with_history) { current_user }

      it { expect(subject.history?).to be true }
    end

    context 'when user is a leader' do
      let(:current_user) { create(:user, :leader) }

      context 'when user want to access his team member' do
        before do
          current_user.teams.first.users << user_with_history
        end
        it { expect(subject.history?).to be true }
      end

      context 'when user want to access different team member' do
        let(:different_leader) { create(:user, :leader) }
        let!(:team) do
          create(
            :team_with_members,
            user_id: different_leader.id,
            users: [different_leader, user_with_history]
          )
        end

        it { expect(subject.history?).to be false }
      end
    end

    context 'when user is talent' do
      let(:current_user) { create(:user, :talent) }
      it { expect(subject.history?).to be true }
    end

    context 'when user is admin' do
      let(:current_user) { create(:user, :admin) }
      it { expect(subject.history?).to be true }
    end
  end

  describe '#skill_access?' do
    context 'when user is a leader' do
      let(:current_user) { create(:user, :leader) }
      it { expect(subject.skill_access?).to be true }
    end

    context 'when user is talent' do
      let(:current_user) { create(:user, :talent) }
      it { expect(subject.skill_access?).to be true }
    end

    context 'when user is admin' do
      let(:current_user) { create(:user, :admin) }
      it { expect(subject.skill_access?).to be true }
    end
  end
end
