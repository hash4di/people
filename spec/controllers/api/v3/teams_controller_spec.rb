require 'spec_helper'

describe Api::V3::TeamsController do
  describe 'GET #index' do
    subject { get :index, params }

    let(:token) { AppConfig.api_token }
    let(:params) { { token: token } }

    let!(:team_1) { create(:team) }
    let!(:team_2) { create(:team) }

    before { subject }
    it { expect(response.status).to eq(200) }

    it 'returns correct values' do
      expect(json_response).to be_kind_of(Array)
      expect(json_response.length).to be(2)
      expect(json_response.first.keys).to contain_exactly(
        'id', 'name', 'color'
      )
    end
  end
end
