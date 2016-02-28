require 'spec_helper'

describe Api::V3::UserWithMembershipsSerializer do
  let!(:object) { create(:user, :junior) }
  let!(:project) { create(:project) }
  let!(:membership) { create(:membership, project: project, user: object) }
  let(:hash) { described_class.new(object).serializable_hash }

  include_examples 'attributes', %w(first_name last_name)

  describe '#primary_role_name' do
    it { expect(hash[:primary_role_name]).to eq('junior') }
  end

  describe 'assosciations' do
    it 'returns membership with project name' do
      expect(hash[:memberships][0][:project_name]).to eq(project.name)
    end
  end
end
