require 'spec_helper'

describe 'Projects page', js: true do
  let!(:admin_user) { create(:user, :admin, :developer) }
  let!(:active_project) { create(:project) }
  let!(:potential_project) { create(:project, :potential) }
  let!(:archived_project) { create(:project, :archived) }
  let!(:potential_archived_project) { create(:project, :potential, :archived) }
  let!(:note) { create(:note) }

  let(:projects_page) { App.new.projects_page }

  before do
    allow_any_instance_of(SendMailJob).to receive(:perform)
    log_in_as admin_user
    projects_page.load
  end

  describe 'tabs' do
    it 'has Active/Potential/Archived tabs' do
      expect(projects_page).to have_active_tab
      expect(projects_page).to have_potential_tab
      expect(projects_page).to have_archived_tab
    end
  end

  describe 'project row' do
    context 'when on Active tab' do
      before { projects_page.active_tab.click }

      it 'has action icon (archive)' do
        expect(projects_page).to have_archive_icons
      end

      it 'displays proper projects' do
        expect(page).to have_content(active_project.name)
        expect(page).not_to have_content(potential_project.name)
        expect(page).not_to have_content(archived_project.name)
        expect(page).not_to have_content(potential_archived_project.name)
      end

      it 'allows adding memberships to an active project' do
        expect(projects_page).to have_member_dropdowns
      end

      describe 'show next' do
        let!(:future_membership) { create(:membership, :future, user: admin_user) }

        before { projects_page.active_tab.click }

        context 'when checked' do
          it 'shows future memberships' do
            check 'show-next'
            expect(projects_page.time_from_elements.size).to_not eq 0
          end
        end

        context 'when unchecked' do
          it 'does not show future memberships' do
            uncheck 'show-next'
            expect(projects_page.time_from_elements.size).to eq 0
          end
        end
      end

      describe 'people in project' do
        let!(:project_membership) { create(:membership, project: active_project) }
        let!(:future_project_membership) { create(:membership, :future, project: active_project) }

        before { projects_page.active_tab.click }

        it 'shows number of present people in project' do
          expect(projects_page.non_billable_counters.first).to have_content('1')
        end
      end
    end

    context 'when on Potential tab' do
      before { projects_page.potential_tab.click }

      it 'displays action icon (archive) when hovered' do
        expect(projects_page).to have_archive_icons
      end

      it 'displays proper projects' do
        page.find('li.potential').click
        expect(page).not_to have_content(active_project.name)
        expect(page).to have_content(potential_project.name)
        expect(page).not_to have_content(archived_project.name)
        expect(page).not_to have_content(potential_archived_project.name)
      end

      it 'allows adding memberships to a potential project' do
        expect(projects_page).to have_member_dropdowns
      end
    end

    context 'when on Archived tab' do
      before { projects_page.archived_tab.click }

      it 'displays all archived projects' do
        expect(page.find_link(archived_project.name)).to be_visible
        expect(page.find_link(potential_archived_project.name)).to be_visible
      end

      it 'does not display active and potential non-archived projects' do
        expect(page).not_to have_content(active_project.name)
        expect(page).not_to have_content(potential_project.name)
      end

      it 'displays action icon (unarchive) when hovered' do
        expect(projects_page).to have_unarchive_icons
      end

      it 'does not allow adding memberships to an archived project' do
        expect(projects_page).to have_no_member_dropdowns
      end
    end
  end

  describe 'project adding' do
    before { visit new_project_path }

    context 'when adding a valid project' do
      context 'with complete data' do
        it 'creates a new project' do
          fill_in('project_name', with: 'Project1')
          fill_in('project_kickoff', with: Date.today)
          fill_in('project_end_at', with: Date.parse(1.year.from_now.to_s))
          check('Potential')
          find('.btn-success').click

          expect(page).to have_content('Project1')
        end
      end
    end

    context 'when adding invalid project' do
      context 'when name is not present' do
        it 'fails with error message' do
          find('.btn-success').click
          expect(page).to have_content('can\'t be blank')
        end
      end
    end
  end

  describe 'project editing' do
    let(:project) { create(:project) }
    before { visit edit_project_path(project) }

    it 'allows to edit project' do
      check('Synchronize with profile?')
      fill_in('project_name', with: 'Edited project')
      fill_in('project_kickoff', with: Date.today)
      fill_in('project_end_at', with: Date.parse(1.year.from_now.to_s))
      find('.btn-success').click
      expect(page).to have_content('Edited project')
    end
  end

  describe 'managing people in project' do
    describe 'adding member to project' do
      it 'adds member to project correctly' do
        projects_page.active_tab.click

        react_select('.project', admin_user.decorate.name)

        expect(projects_page.billable_counters.first).to have_content('1')
      end
    end

    describe 'ending membership in a regular project' do
      let!(:membership) { create(:membership, user: admin_user, project: active_project, ends_at: nil) }

      before { projects_page.active_tab.click }

      it 'sets and end date for a membership' do
        expect(projects_page.time_to_elements.size).to eq 0

        within('div.project') do
          find('.member-name').hover
          find('.icons .remove').click
          wait_for_ajax
        end

        expect(projects_page.time_to_elements.size).to_not eq 0
      end
    end
  end

  describe 'managing notes' do
    describe 'add a new note' do
      before do
        projects_page.active_tab.click
        find('.show-notes').click
      end

      it 'add a note to the project' do
        expect(page).not_to have_selector('div.note-group')
        find('input.new-project-note-text').set('Test note')
        find('a.new-project-note-submit').click
        expect(page.find('div.note-group', text: 'Test note')).to be_visible
      end
    end

    describe 'remove note' do
      before do
        create(:note, user: admin_user, project: active_project)
        projects_page.active_tab.click
        find('.show-notes').click
      end

      it 'remove a note' do
        expect(page).to have_selector('div.note-group')
        expect(page).to have_content(note.text)

        find('.note-remove').click
        expect(page).not_to have_selector('project-notes-wrapper')
        expect(page).not_to have_content(note.text)
      end
    end
  end
end
