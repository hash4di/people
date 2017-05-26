require 'spec_helper'

describe 'Authentication', js: true do
  subject { page }
  before(:all) { OmniAuth.config.test_mode = true }

  context 'sign in' do
    let(:internal_domain) { AppConfig.emails.internal }
    let(:user) do
      build(:user, first_name: 'John', last_name: 'Doe', email: "jdoe@#{internal_domain}")
    end
    before do
      OmniAuth.config.add_mock(
        :google_oauth2,
        {
          info: {
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
          },
          extra: { raw_info: { hd: internal_domain } },
          credentials: {
            oauth_token: 123,
            refresh_token: 456,
            oauth_expires_at: Time.now + 1.hour
          }
        }
      )
    end

    context 'with google' do
      before do
        visit root_path
        click_link_or_button 'Sign up with Google'
        allow_any_instance_of(Apiguru::ListUsers).to receive(:call).and_return []
      end

      it { should have_content('Now please connect your GitHub account.') }

      context 'and github account' do
        before do
          OmniAuth.config.add_mock(:github, info: { nickname: 'xyz' })
          click_link_or_button 'connect'
        end

        it 'redirects to the dashboard' do
          expect(page).to have_content('Projects')
        end
      end
    end
  end

  context 'sign in without GH account' do
    let(:second_usr) do
      create(
        :user,
        first_name: 'Greg',
        gh_nick: nil,
        last_name: 'Doe',
        email: 'grdoe@sth.com',
        without_gh: true
      )
    end
    before { sign_in(second_usr) }

    it 'redirects to the dashboard' do
      wait_for_ajax
      expect(page).to have_content('Projects')
    end
  end
end
