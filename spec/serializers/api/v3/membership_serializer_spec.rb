require 'spec_helper'

describe Api::V3::MembershipSerializer do
  let(:project) { create(:project) }
  let(:role) { create(:role) }
  let(:object) { create(:membership, project: project, role: role) }
  let(:subject) { described_class.new(object).serializable_hash }

  it { expect(subject[:project_name]).to eq(project.name) }
  it { expect(subject[:role_name]).to eq(role.name) }
  it { expect(subject[:potential]).to eq(project.potential) }
  include_examples 'attributes', %w(starts_at ends_at)
end
