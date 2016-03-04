require 'spec_helper'

describe 'Profile page', js: true do
  subject { page }

  let(:role) { create(:role) }
  let(:user) { create(:user, :admin, primary_role: role) }

  before do
    log_in_as(user)
  end

  context 'has billable role' do
    before do
      user.primary_role.update_attribute(:billable, true)
      visit user_path(user.id)
    end

    it { expect(page.find('[name="membership[billable]"]').value).to eq "1" }
  end

  context 'label and checkbox are both clickable' do
    it 'checkbox sets value to true' do
      visit user_path(user)
      check('membership_billable')

      expect(page.find('#membership_billable')).to be_checked
    end

    it 'label sets value to true' do
      visit user_path(user)
      page.find('label', text: 'Billable').click

      expect(page.find('#membership_billable')).to be_checked
    end

  end
end
