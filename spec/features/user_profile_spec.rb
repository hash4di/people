require 'spec_helper'

describe 'profile', js: true do
  let!(:junior_role) { create(:junior_role) }
  let!(:developer_role) { create(:role, name: 'developer') }
  let(:position) { create(:position, role: junior_role, primary: false) }

  before do
    log_in_as(position.user)
  end

  describe 'setting primary role' do
    before { visit user_path(position.user.id) }

    it 'sets role as primary using a slider' do
      find('.primary-slider').click
      wait_for_ajax

      expect(position.reload.primary).to be true
    end
  end

  describe 'adding positions' do
    before { visit user_path(position.user.id) }

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
end
