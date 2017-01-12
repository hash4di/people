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

    context 'with api token and user email' do
      before { get :index, token: token, user_email: user.email }

      it { expect(response.status).to eq(200) }

      it 'returns correct hash', :aggregate_failures do
        skill_rates = json_response['user_skill_rates']['skill_rates']
        expect(skill_rates).to be_a(Array)
        expect(skill_rates.size).to eq(2)
      end
    end
  end
end
