require 'spec_helper'

describe UserSkillRatesController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#index' do
    let(:skill_category_backend) { create(:skill_category, name: 'backend') }
    let(:skill_category_frontend) { create(:skill_category, name: 'frontend') }
    let(:skill_backend) { create(:skill, skill_category: skill_category_backend) }
    let(:skill_frontend) { create(:skill, skill_category: skill_category_frontend) }
    let!(:user_skill_rate_backend) { create(:user_skill_rate, user: user, skill: skill_backend ) }
    let!(:user_skill_rate_frontend) { create(:user_skill_rate, user: user, skill: skill_frontend ) }

    subject { get :index }

    it 'responds successfully with an HTTP 200 status code' do
      subject
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'exposes user skill rates grouped by category' do
      subject
      expect(controller.grouped_skills_by_category.values.count).to eq(2)
      expect(controller.grouped_skills_by_category.keys).to include('backend', 'frontend')
      expect(controller.grouped_skills_by_category['backend']).to include(user_skill_rate_backend)
      expect(controller.grouped_skills_by_category['frontend']).to include(user_skill_rate_frontend)
    end

    it 'renders index view' do
       expect(subject).to render_template(:index)
    end
  end

  describe '#update' do
    subject do
      put :update, id: user_skill_rate.id, user_skill_rate: params, format: :json
    end

    let(:user_skill_rate) do
      create(:user_skill_rate, note: 'abc', rate: 0, favorite: false, user: user)
    end

    let(:params) {
      {
        id: user_skill_rate.id,
        note: 'def',
        rate: 1,
        favorite: true
      }
    }

    it 'updates note on user rate skill' do
      expect{ subject }.to change{ user_skill_rate.reload.note }.from('abc').to('def')
    end

    it 'updates favorite on user rate skill' do
      expect{ subject }.to change{ user_skill_rate.reload.rate }.from(0).to(1)
    end

    it 'updates favorite on user favorite skill' do
      expect{ subject }.to change{ user_skill_rate.reload.favorite }.from(false).to(true)
    end

    it 'responds successfully with an HTTP 204 status code' do
      subject
      expect(response).to be_success
      expect(response.status).to eq(204)
    end
  end
end
