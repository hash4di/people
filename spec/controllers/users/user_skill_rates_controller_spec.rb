require 'spec_helper'

describe Users::UserSkillRatesController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#history' do
    subject { get :history, id: user.id }

    let(:skill_category) { create(:skill_category) }

    it { expect(subject).to render_template(:history) }

    it 'responds successfully with an HTTP 200 status code' do
      subject
      aggregate_failures do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end
    end

    it 'exposes user and skill categories' do
      subject
      expect(controller.user).to eq(user)
      expect(controller.skill_categories).to eq([skill_category])
    end
  end
end
