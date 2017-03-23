require 'spec_helper'

describe Api::V2::UsersController do
    let(:token) { AppConfig.api_token }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user, archived: true) }

  describe 'GET #all' do
    before { get :all, token: token }

    it { expect(response.status).to eq(200) }
    it { expect(json_response.length).to eq(3) }
  end

  describe 'GET #index' do
    before { get :index, token: token }

    it { expect(response.status).to eq(200) }
    it { expect(json_response.length).to eq(2) }
  end
end
