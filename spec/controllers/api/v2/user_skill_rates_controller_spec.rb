require 'spec_helper'

describe Api::V2::UserSkillRatesController do
  describe 'GET #index' do
    let(:user_1) { create(:user, email: 'john.smith@netguru.pl') }
    let(:user_2) { create(:user, email: 'john.kowalski@netguru.pl') }
    let(:skill_1) { create(:skill) }
    let(:skill_2) { create(:skill) }
    let!(:user_skill_rate_1) do
      create(:user_skill_rate, user: user_1, skill: skill_1, rate: 3)
    end
    let!(:user_skill_rate_2) do
      create(:user_skill_rate, user: user_2, skill: skill_1, rate: 3)
    end
    let!(:user_skill_rate_without_rate) do
      create(:user_skill_rate, user: user_1, skill: skill_2, rate: 0)
    end
    let(:token) { AppConfig.api_token }
    let(:user_email) { 'asdasd@netguru.pl' }
    let(:scope) { '' }

    before { get :index, token: token, user_email: user_email, scope: scope }

    context 'without api token' do
      let(:token) { nil }
      it 'returns response status 403' do
        expect(response.status).to eq 403
      end
    end

    context 'with api token' do
      let(:token) { AppConfig.api_token }

      context 'without scope' do
        let(:scope) { '' }
        it_behaves_like 'returns empty hash and response is 200'
      end

      context 'with scope all' do
        let(:scope) { 'all' }
        let(:expected_array) do
          [
            {
              'ref_name' => user_skill_rate_1.skill.ref_name,
              'rate' => user_skill_rate_1.rate,
              'email' => user_skill_rate_1.user.email
            },
            {
              'ref_name' => user_skill_rate_2.skill.ref_name,
              'rate' => user_skill_rate_2.rate,
              'email' => user_skill_rate_2.user.email
            }
          ]
        end

        it_behaves_like 'returns correct hash and response is 200'
      end

      context 'with scope user' do
        let(:scope) { 'user' }
        context 'with invalid user_email' do
          let(:user_email) { 'invalid.user@email.co' }
          it_behaves_like 'returns empty hash and response is 200'
        end

        context 'with valid user_email' do
          let(:user_email) { user_1.email }
          let(:expected_array) do
            [
              {
                'ref_name' => user_skill_rate_1.skill.ref_name,
                'rate' => user_skill_rate_1.rate,
                'email' => user_skill_rate_1.user.email
              },
            ]
          end
          it_behaves_like 'returns correct hash and response is 200'

          context 'with user_email from different domain' do
            let(:user_email) { 'john.smith@netguru.co' }
            it_behaves_like 'returns correct hash and response is 200'
          end
        end
      end
    end
  end
end
