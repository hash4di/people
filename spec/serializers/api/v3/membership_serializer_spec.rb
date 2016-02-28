require 'spec_helper'

describe Api::V3::MembershipSerializer do
  let(:project) { create(:project) }
  let(:role) { create(:role) }
  let(:object) { create(:membership, project: project, role: role) }
  let(:hash) { described_class.new(object).serializable_hash }

  it { expect(hash[:project_name]).to eq(project.name) }
  it { expect(hash[:role_name]).to eq(role.name) }
  it { expect(hash[:potential]).to eq(project.potential) }
  include_examples 'attributes', %w(starts_at ends_at)
end
