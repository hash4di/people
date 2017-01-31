require 'spec_helper'

describe UserPolicy do
  subject { UserPolicy.new(leader, team_member) }

  let(:leader) { create(:user) }
  let!(:team) { create(:team_with_members, user_id: leader.id, users: [leader]) }
  let(:team_member) { team.users.sample }

  before { team.reload }

  it { expect(subject.history?).to be true }
end
