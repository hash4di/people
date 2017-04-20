require 'spec_helper'

describe Api::V3::UsersController do
  describe 'GET #technical' do
    let(:token) { AppConfig.api_token }
    let!(:developer) { create(:developer_in_project) }
    let!(:pm) { create(:pm_user) }

    before { get :technical, token: token }

    it { expect(response.status).to eq(200) }
    it { expect(json_response.length).to eq(1) }
  end

  describe 'GET #sign_in' do
    before { get :sign_in, params }
    let(:user) { create(:user) }
    let(:params) { { api_token: api_token, email: email } }
    let(:api_token) { user.api_token }
    let(:email) { user.email }

    context 'when api_token and email exists' do
      it { expect(response.status).to eq(200) }
    end

    context "when api_token and email doesn't exist" do
      let(:api_token) { 'incorrect' }
      it { expect(response.status).to eq(403) }
    end
  end
end
