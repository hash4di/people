require 'spec_helper'

describe ProjectInfoController do
  let(:admin_user) { create(:user, :admin) }

  before { sign_in(admin_user) }

  describe '#index' do
    render_views
    let(:projects_array) { ['Reality Royale', 'UPFitness', 'Access_Internal'] }

    before do
      allow_any_instance_of(Apiguru::ListProjects)
        .to receive(:call)
        .and_return(projects_array)
      get :index
    end

    it 'responds successfully with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'exposes projects' do
      expect(controller.project_infos).to eq projects_array
    end

    it 'displays projects on view' do
      expect(response.body).to match(/Reality Royale/)
      expect(response.body).to match(/UPFitness/)
      expect(response.body).to match(/Access_Internal/)
    end
  end

  describe '#show' do
    render_views
    let(:project) { { name: 'ABC', project_active: true } }

    before do
      allow_any_instance_of(Apiguru::ShowProjectInfo)
        .to receive(:call)
        .and_return(project)
      get :show, name: 'ABC'
    end

    it 'responds successfully with an HTTP 200 status code' do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'exposes project' do
      expect(controller.project_info).to eq project
    end

    it 'displays project' do
      expect(response.body).to match(%r{<h1>ABC<\/h1>})
    end
  end
end
