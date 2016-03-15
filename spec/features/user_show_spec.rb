require 'spec_helper'

describe 'User profile', js: true do
  let!(:user) { create(:user, :admin) }
  let!(:junior_role) { create(:junior_role) }
  let!(:developer_role) { create(:dev_role) }
  let!(:position) { create(:position, user: user, role: junior_role, primary: false) }

  let!(:user_profile_page) { App.new.user_profile_page }

  before do
    log_in_as user
    user_profile_page.load user_id: user.id
  end

  describe 'setting primary role' do
    it 'sets role as primary using a slider' do
      expect(position.primary).to be false
      user_profile_page.primary_role_sliders.first.click
      wait_for_ajax
      expect(position.reload.primary).to be true
    end
  end

  describe 'adding positions' do
    it 'adds a position to user' do
      within('.user-positions') do
        expect(page).to have_text(junior_role.name)
        expect(page).to_not have_text(developer_role.name)
        click_link('Add position')
      end

      within('form.new_position') do
        select(developer_role.name, from: 'position_role_id')
        select(
          "#{position.user.last_name} #{position.user.first_name}",
          from: 'position_user_id'
        )

        fill_in(
          'position_starts_at',
          with: (position.starts_at + 1.year).strftime('%Y-%m-%d')
        )

        click_button('Create Position')
      end

      within('.user-positions') { expect(page).to have_text(developer_role.name) }
    end
  end

  describe 'rendering timeline on profile' do
    let(:user) { create(:developer_in_project) }
    before { visit user_path(user.id) }
    it_behaves_like 'has timeline visible'
    it_behaves_like 'has timeline event visible'
  end

  describe 'label and checkbox are both clickable' do
    it 'checkbox sets value to true' do
      check('membership_billable')

      expect(page.find('#membership_billable')).to be_checked
    end

    it 'label sets value to true' do
      page.find('label', text: 'Billable').click

      expect(page.find('#membership_billable')).to be_checked
    end
  end
end
