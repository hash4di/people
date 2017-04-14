require 'spec_helper'

describe Api::V3::TeamMembersController do
  describe 'GET #index' do
    subject { get :index, params }

    let!(:team) do
      create(
        :team,
        name: 'alpha',
        users: [team_member_1, team_member_2]
      )
    end
    let(:team_member_1) { create(:user) }
    let(:team_member_2) { create(:user) }
    let(:team_member_2) { create(:user, :archived) }

    let(:token) { AppConfig.api_token }
    let(:params) do
      {
        token: token,
        team_name: 'alpha',
      }
    end

    before { subject }
    it { expect(response.status).to eq(200) }

    it 'returns correct values' do
      expect(json_response).to be_kind_of(Array)
      expect(json_response.length).to be(2)
      expect(json_response.first.keys).to contain_exactly(
        'id', 'email', 'full_name'
      )
    end
  end
end
