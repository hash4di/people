require 'spec_helper'

describe AccountSettingsController do
  render_views

  let(:user) { create(:user) }
  before { sign_in(user) }

  describe '#index' do
    before { get :index }

    it 'responds successfully with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end

  describe '#generate' do
    subject { get :generate }

    it 'responds successfully with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'changes api_token for current user' do
      expect{ subject }.to change{ user.reload.api_token }
    end
  end
end
