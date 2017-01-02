require 'spec_helper'

describe Api::V2::UserSkillRatesController do
  describe 'GET #index' do
    let(:token) { AppConfig.api_token }
    let(:user) { create :user }
    let(:skill) { create :skill }
    let!(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill, rate: 3) }
    let!(:user_skill_rate2) { create(:user_skill_rate, user: user, skill: skill) }

    context 'without api token' do
      it 'returns response status 403' do
        get :index
        expect(response.status).to eq 403
      end
    end

    context 'with api token and without user id' do
      let(:request) { get :index, token: token }

      it 'returns ActiveRecord::RecordNotFound error' do
        expect { request }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'with api token and user id' do
      before { get :index, token: token, user_id: user.id }

      it { expect(response.status).to eq(200) }

      it 'returns correct hash', :aggregate_failures do
        response = json_response['user_skill_rates']['user_with_skill_rates']
        expect(response.keys).to include(user.email)
        expect(response[user.email].length).to eq(2)
      end
    end
  end
end
