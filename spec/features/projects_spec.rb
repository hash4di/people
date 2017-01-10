require 'spec_helper'

describe 'Projects dashboard page', js: true do
  let!(:admin_user) { create(:user, :admin, :developer) }
  let!(:active_project) { create(:project) }
  let!(:potential_project) { create(:project, :potential) }
  let!(:archived_project) { create(:project, :archived) }
  let!(:potential_archived_project) { create(:project, :potential, :archived) }

  let(:projects_page) { App.new.projects_page }

  let(:go_to_active_tab) { visit '/dashboard/active' }
  let(:go_to_potential_tab) { visit '/dashboard/potential' }
  let(:go_to_archived_tab) { visit '/dashboard/archived' }

  before do
    allow_any_instance_of(SendMailJob).to receive(:perform)
    log_in_as admin_user
    projects_page.load
  end

  describe 'sections' do
    it 'has all the expected sections' do
      expect(projects_page).to have_project_types
      expect(projects_page).to have_project_filters
      expect(projects_page).to have_projects
      expect(projects_page).to have_new_project_button
    end

    it 'has Active/Potential/Archived tabs' do
      expect(projects_page.project_types).to have_active_tab
      expect(projects_page.project_types).to have_potential_tab
      expect(projects_page.project_types).to have_archived_tab
    end

    it 'has all the dropdown and checkbox filters' do
      expect(projects_page.project_filters).to have_roles_filter
      expect(projects_page.project_filters).to have_projects_filter
      expect(projects_page.project_filters).to have_users_filter
      expect(projects_page.project_filters).to have_ending_checkbox
      expect(projects_page.project_filters).to have_next_checkbox
    end
  end

  describe 'project row' do
    context 'when on Active tab' do
      it 'has action icon (archive)' do
        go_to_active_tab
        expect(projects_page.projects.first).to have_archive_icon
      end

      it 'displays proper projects' do
        go_to_active_tab
        expect(projects_page).to have_content active_project.name
        expect(projects_page).not_to have_content potential_project.name
        expect(projects_page).not_to have_content archived_project.name
        expect(projects_page).not_to have_content potential_archived_project.name
      end

      it 'allows adding memberships to an active project' do
        go_to_active_tab
        expect(projects_page.projects.first).to have_member_dropdown
      end

      describe 'show next' do
        let!(:future_membership) { create(:membership, :future, project: active_project) }

        before { go_to_active_tab }

        context 'when checked' do
          it 'shows future memberships' do
            projects_page.project_filters.next_checkbox.click
            expect(projects_page.projects.first).to have_time_from_element
          end
        end

        context 'when unchecked' do
          it 'does not show future memberships' do
            expect(projects_page.projects.first).to_not have_time_from_element
          end
        end
      end

      describe 'people in project' do
        let!(:project_membership) { create(:membership, project: active_project) }
        let!(:future_project_membership) { create(:membership, :future, project: active_project) }

        before { go_to_active_tab }

        it 'shows number of present people in project' do
          expect(projects_page.projects.first.non_billable_counter).to have_content '1'
        end
      end
    end

    context 'when on Potential tab' do
      before { go_to_potential_tab }

      it 'displays action icon (archive)' do
        expect(projects_page.projects.first).to have_archive_icon
      end

      it 'displays proper projects' do
        expect(page).not_to have_content active_project.name
        expect(page).to have_content potential_project.name
        expect(page).not_to have_content archived_project.name
        expect(page).not_to have_content potential_archived_project.name
      end

      it 'allows adding memberships to a potential project' do
        expect(projects_page.projects.first).to have_member_dropdown
      end
    end

    context 'when on Archived tab' do
      before { go_to_archived_tab }

      it 'displays all archived projects' do
        expect(projects_page).to have_content archived_project.name
        expect(projects_page).to have_content potential_archived_project.name
      end

      it 'does not display active and potential non-archived projects' do
        expect(projects_page).not_to have_content active_project.name
        expect(projects_page).not_to have_content potential_project.name
      end

      it 'displays action icon (unarchive)' do
        expect(projects_page.projects.first).to have_unarchive_icon
      end

      it 'does not allow adding memberships to an archived project' do
        expect(projects_page.projects.first).to have_no_member_dropdown
      end
    end
  end

  describe 'managing people in projects' do

    describe 'adding member to project' do
      before { go_to_active_tab }


      it 'adds member to project correctly' do
        react_select('.project', admin_user.decorate.name)
        expect(projects_page.projects.first.billable_counter).to have_content '1'
      end
    end

    describe 'ending membership in a regular project' do
      let!(:membership) { create(:membership, user: admin_user, project: active_project, ends_at: nil) }

      before { go_to_active_tab }

      it 'sets and end date for a membership' do
        expect(projects_page.projects.first).to_not have_time_to_element
        page.execute_script "$('.js-project-memberships.memberships').trigger('mouseover')"
        find('.icons .remove').click
        wait_for_ajax
        expect(projects_page.projects.first).to have_time_to_element
      end
    end
  end

  describe 'managing notes' do
    describe 'add a new note' do
      before do
        go_to_active_tab
        projects_page.projects.first.notes_button.click
      end

      it 'add a note to the project' do
        expect(projects_page.projects.first).to_not have_notes
        projects_page.projects.first.new_note_field.set 'Test note'
        projects_page.projects.first.new_note_button.click
        wait_for_ajax
        expect(projects_page.projects.first).to have_notes
      end
    end

    describe 'remove note' do
      let!(:note) { create(:note) }

      before do
        create(:note, user: admin_user, project: active_project)
        go_to_active_tab
        projects_page.projects.first.notes_button.click
      end

      it 'remove a note' do
        expect(projects_page.projects.first).to have_notes
        expect(projects_page).to have_content(note.text)

        projects_page.projects.first.note_remove_buttons.first.click
        wait_for_ajax
        expect(projects_page.projects.first).to have_no_notes
        expect(projects_page).not_to have_content(note.text)
      end
    end
  end
end
