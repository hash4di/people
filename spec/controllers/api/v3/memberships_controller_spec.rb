require 'spec_helper'

describe Api::V3::MembershipsController do
  describe 'GET #index' do

    subject { get :index, params }

    let(:requested_user) { create(:user) }
    let(:user) { create(:user) }
    let(:f2f_date) { Time.now - 4.months }
    let(:filter_params) do
      { user_email: requested_user.email, f2f_date: f2f_date }
    end

    let(:requested_user_project) { create(:project) }
    let!(:membership_1) do
      create(
        :membership,
        project: requested_user_project,
        user: requested_user,
        starts_at: f2f_date - 6.months,
        ends_at: f2f_date + 1.months
      )
    end
    let!(:membership_2) do
      create(
        :membership,
        project: requested_user_project,
        user: user,
        starts_at: f2f_date - 5.months,
        ends_at: f2f_date + 2.months
      )
    end

    let(:token) { AppConfig.api_token }
    let(:params) do
      {
        token: token,
        user_email: user.email,
        f2f_date: f2f_date
      }
    end

    before { subject }

    it { expect(response.status).to eq(200) }

    it 'returns correct values' do
      expect(json_response).to be_kind_of(Array)
      expect(json_response.first.keys).to contain_exactly(
        'project_name', 'user_name', 'user_email', 'user_role'
      )
    end
  end
end
