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

  describe '#edit' do
    subject { get :edit, id: skill.id }

    context 'when request for change already exists' do
      let(:skill) { create(:skill, :with_awaiting_change_request) }

      it 'redirects to root_path' do
        expect(subject).to redirect_to(root_path)
      end
    end

    context 'when request for change does not exist' do
      it 'renders correct template' do
        expect(subject).to render_template(:edit)
      end
    end
  end

end
