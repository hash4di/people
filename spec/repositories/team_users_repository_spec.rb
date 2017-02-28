require 'spec_helper'

describe TeamUsersRepository do
  let(:user) { create(:user) }
  let(:team) { create(:team_with_members, user_id: user.id, users: [user]) }

  before { team.reload }

  subject { TeamUsersRepository.new(team) }

  describe '#all' do
    it 'retrieves all users' do
      expect(subject.all.count).to eq User.count
    end
  end

  describe '#leader' do
    it 'retrieves leader' do
      expect(subject.leader).to eq user
    end
  end

  describe '#subordinates' do
    it 'retrieves all users except leader' do
      expect(subject.subordinates).not_to include user
    end
  end
end
