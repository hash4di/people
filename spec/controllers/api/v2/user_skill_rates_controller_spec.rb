require 'spec_helper'

describe Api::V2::UserSkillRatesController do
  describe 'GET #index' do
    let(:token) { AppConfig.api_token }
    let(:user) { create(:user, email: 'john.smith@netguru.pl') }
    let(:skill1) { create(:skill) }
    let(:skill2) { create(:skill) }
    let(:unknown_email) { 'asdasd@netguru.pl' }
    let!(:user_skill_rate1) { create(:user_skill_rate, user: user, skill: skill1, rate: 3) }
    let!(:user_skill_rate2) { create(:user_skill_rate, user: user, skill: skill2, rate: 1) }

    context 'without api token' do
      it 'returns response status 403' do
        get :index
        expect(response.status).to eq 403
      end
    end

    context 'with api token and invalid user_email' do
      before { get :index, token: token, user_email: unknown_email }

      it { expect(response.status).to eq(200) }

      it 'returns correct hash', :aggregate_failures do
        skill_rates = json_response['user_skill_rates']
        expect(skill_rates).to be_a(Array)
        expect(skill_rates.size).to eq(0)
      end
    end

    context 'with api token and valid user_email' do
      before { get :index, token: token, user_email: user.email }

      it { expect(response.status).to eq(200) }

      it 'returns correct hash', :aggregate_failures do
        skill_rates = json_response['user_skill_rates']
        expect(skill_rates).to be_a(Array)
        expect(skill_rates)
          .to eq(
            [
              { 'ref_name' => skill1.ref_name.to_s, 'rate' => user_skill_rate1.rate },
              { 'ref_name' => skill2.ref_name.to_s, 'rate' => user_skill_rate2.rate },
            ]
          )
      end
    end

    context 'with api token and user_email with different domain' do
      before { get :index, token: token, user_email: 'john.smith@netguru.co' }

      it { expect(response.status).to eq(200) }

      it 'returns correct hash', :aggregate_failures do
        skill_rates = json_response['user_skill_rates']
        expect(skill_rates).to be_a(Array)
        expect(skill_rates)
        expect(skill_rates)
          .to eq(
            [
              { 'ref_name' => skill1.ref_name.to_s, 'rate' => user_skill_rate1.rate },
              { 'ref_name' => skill2.ref_name.to_s, 'rate' => user_skill_rate2.rate },
            ]
          )
      end
    end
  end
end
