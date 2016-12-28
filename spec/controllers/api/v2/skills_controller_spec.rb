require 'spec_helper'

describe Api::V2::SkillsController do
  describe 'GET #index' do
    let(:token) { AppConfig.api_token }
    let!(:skill1) { create(:skill) }
    let!(:skill2) { create(:skill) }

    context 'without api token' do
      it 'returns response status 403' do
        get :index
        expect(response.status).to eq 403
      end
    end

    context 'with api token' do
      before { get :index, token: token }

      it { expect(response.status).to eq(200) }
      it { expect(json_response.length).to eq(2) }
    end
  end
end
