require 'spec_helper'

describe 'Adding new project', js: true do
  let!(:admin_user) { create :user, :admin }

  let!(:project_new_page) { ProjectNewPage.new }

  before do
    log_in_as admin_user
    project_new_page.load
  end

  context 'when adding a valid project' do
    context 'with complete data' do
      it 'creates a new project' do
        fill_in('project_name', with: 'Project1')
        fill_in('project_kickoff', with: Date.today)
        fill_in('project_end_at', with: Date.parse(1.year.from_now.to_s))
        check('Potential')
        project_new_page.save_button.click

        expect(project_new_page).to have_content('Project1')
      end
    end
  end

  context 'when adding invalid project' do
    context 'when name is not present' do
      it 'fails with error message' do
        check('Potential')
        project_new_page.save_button.click

        expect(project_new_page).to have_content('can\'t be blank')
      end
    end
  end

  context 'maintenance project' do
    it "displays additional date selector for 'Maintenance since'" do
      expect(project_new_page).to_not have_content('* Maintenance since')
      select('Maintenance', from: 'project_project_type')
      expect(project_new_page).to have_content('* Maintenance since')
      expect(project_new_page).to have_content('* Maintenance since')
    end

    it "displays error when 'Maintenance since' is not filled" do
      fill_in('project_name', with: 'Maintenance Project')
      fill_in('project_kickoff', with: Date.today)
      fill_in('project_end_at', with: Date.parse(1.month.from_now.to_s))
      select('Maintenance', from: 'project_project_type')
      project_new_page.save_button.click

      expect(project_new_page).to have_content('can\'t be blank')
    end
  end
end
