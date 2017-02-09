require 'spec_helper'

describe SkillsController do
  let(:admin_user) { create(:user, :admin) }
  let(:skill) { create(:skill, name: 'Git') }

  before { sign_in(admin_user) }

  describe '#index' do
    subject { get :index }
    it 'renders correct template' do
      expect(subject).to render_template(:index)
    end
  end

  describe '#new' do
    subject { get :new }
    it 'renders correct template' do
      expect(subject).to render_template(:new)
    end
  end

  describe '#show' do
    subject { get :show, id: skill.id }
    it 'renders correct template' do
      expect(subject).to render_template(:show)
    end
  end
end
