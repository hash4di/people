require 'spec_helper'

describe 'Users page', js: true do
  let!(:developer) { create(:user, :developer) }

  let!(:users_page) { App.new.users_page }

  before do
    log_in_as developer
    users_page.load
  end

  it 'shows user roles' do
    developer.primary_roles.each { |role| expect(page).to have_content(role.name) }
  end

  context 'position names' do
    let!(:previous_position) { create(:position, user: developer, primary: false) }

    before { users_page.load }

    it 'shows only current position name' do
      expect(page).not_to have_content(previous_position.role.name)
    end
  end

  context 'internal project' do
    let!(:project) { create(:project, :internal) }
    let!(:membership) { create(:membership, project: project, user: developer) }

    before { users_page.load }

    it "doesn't show nonbillable sign" do
      expect(users_page).to have_no_nonbillable_signs
    end
  end

  context 'commercial project' do
    let!(:project) { create(:project, :commercial) }

    context 'billable membership' do
      let!(:membership) { create(:membership, :billable, project: project, user: developer) }

      before { users_page.load }

      it "doesn't show nonbillable sign" do
        expect(users_page).to have_no_nonbillable_signs
      end
    end

    context 'non-billable membership' do
      let!(:membership) { create(:membership, project: project, user: developer) }

      before { users_page.load }

      it 'shows nonbillable sign' do
        expect(users_page).to have_nonbillable_signs
      end
    end
  end

  context 'potential booked project' do
    let!(:potential_project) { create(:project, :potential) }
    let!(:membership) { create(:membership, :booked, project: potential_project, user: developer) }

    before { users_page.load }

    it 'shows potential sign' do
      expect(users_page).to have_potential_signs
    end
  end

  context 'hide toggle admin column if not admin' do
    it { expect(users_page.has_toggle_admin_checkboxes?).to eq(false) }
  end

  context 'show toggle admin column if not admin' do
    before do
      developer.update(admin: true)
      users_page.load
    end
    it { expect(users_page.has_toggle_admin_checkboxes?).to eq(true) }
  end
end
