require 'spec_helper'
require 'rake'

describe 'users tasks' do
  before(:all) do
    Rake.application.rake_require('tasks/users')
    Rake::Task.define_task(:environment)
  end

  describe 'users:generate_default_user_skills' do
    let(:run_rake_task) do
      Rake::Task['users:generate_default_user_skills'].reenable
      Rake.application.invoke_task 'users:generate_default_user_skills'
    end

    let(:user) { create(:user) }
    let!(:rated_skill) { create(:skill) }
    let!(:non_assigned_skill) { create(:skill) }

    before do
      create(:user_skill_rate, skill: rated_skill, user: user, rate: 1)
    end

    it 'generates skills for users' do
      run_rake_task

      expect(user.reload.skills).to include(non_assigned_skill)
    end
  end
end
