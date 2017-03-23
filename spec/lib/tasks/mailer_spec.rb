require 'spec_helper'
require 'rake'
Hrguru::Application.load_tasks

describe "mailer namespace rake tasks" do
  before(:all) do
    Rake::Task.define_task(:environment)
  end

  before { allow(SendMailJob).to receive(:perform_async).and_return(true) }

  shared_examples 'executes send job' do
    it 'send mail' do
      expect(SendMailJob).to receive(:perform_async)
      run_rake_task
    end
  end

  shared_examples 'does not execute send job' do
    it 'doesnt send mail' do
      expect(SendMailJob).not_to receive(:perform_async)
      run_rake_task
    end
  end

  describe 'mailer:users_without_primary_role' do
    let(:run_rake_task) do
      Rake::Task['mailer:users_without_primary_role'].reenable
      Rake.application.invoke_task 'mailer:users_without_primary_role'
    end

    context 'when everyone have role' do
      include_examples 'does not execute send job'
    end

    context "when someone doesn't have primary role" do
      let!(:user) { create(:user, primary_role: nil) }

      include_examples 'executes send job'
    end
  end

  describe 'mailer:users_with_unread_notifications' do
    let(:run_rake_task) do
      Rake::Task['mailer:users_with_unread_notifications'].reenable
      Rake.application.invoke_task 'mailer:users_with_unread_notifications'
    end

    context 'when there is no user with unread notification' do
      include_examples 'does not execute send job'
    end

    context 'when there is archived user with unread notification' do
      let!(:user) { create(:user, :archived) }
      let!(:notification) { create(:notification, :unread, receiver: user) }

      include_examples 'does not execute send job'
    end

    context 'when there is active user with unread notification' do
      let!(:user) { create(:user, archived: false) }
      let!(:notification) { create(:notification, :unread, receiver: user) }

      include_examples 'executes send job'
    end
  end
end
