require 'spec_helper'

describe Api::V3::MembershipsHistorySerializer do
  let(:project) { create(:project) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let(:object) { create(:membership, project: project, role: role, user: user) }
  let(:subject) { described_class.new(object).serializable_hash }
  let(:user_full_name) { "#{user.first_name} #{user.last_name}" }

  it { expect(subject[:project_name]).to eq(project.name) }
  it { expect(subject[:user_role]).to eq(role.name) }
  it { expect(subject[:user_name]).to eq(user_full_name) }
  it { expect(subject[:user_email]).to eq(user.email) }
end
