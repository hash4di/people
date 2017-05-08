require 'spec_helper'

describe Api::V3::TeamMemberSerializer do
  let(:team_member) { create(:user) }
  let(:subject) { described_class.new(team_member).serializable_hash }
  let(:user_full_name) { "#{team_member.first_name} #{team_member.last_name}" }

  it { expect(subject[:id]).to eq(team_member.id) }
  it { expect(subject[:email]).to eq(team_member.email) }
  it { expect(subject[:full_name]).to eq(user_full_name) }
end
