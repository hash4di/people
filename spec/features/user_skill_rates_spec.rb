require 'spec_helper'

describe 'User skill rates page', js: true do
  let(:user_skill_rates_page) { App.new.user_skill_rates_page }

  let(:skill_category_1) { create :skill_category, name: 'backend' }
  let(:skill_category_2) { create :skill_category, name: 'ios' }

  let(:skills_range) { create_list :skill, 2, :with_range_rate_type, skill_category: skill_category_1 }
  let(:skills_boolean) { create_list :skill, 2, :with_boolean_rate_type, skill_category: skill_category_2 }

  let!(:developer) { create(:user, :developer, skills: skills_range + skills_boolean) }



  context 'when user does not have any marked skills' do
    before do
      log_in_as developer
      user_skill_rates_page.load
    end

    def skill_rate_trigger(num, event_name)
      page.execute_script "$('.glyphicon.skill__rate[data-rate=\"#{num}\"]:first').trigger('#{event_name}')"
    end

    it 'checks tooltips' do
      3.times do |num|
        skill_rate_trigger(num + 1, 'mouseover')
        expect(user_skill_rates_page).to have_content I18n.t('skills.rating.range')[num + 1]
        skill_rate_trigger(num + 1, 'blur')
      end
      page.execute_script "$('.skill__favorite').trigger('mouseover')"
      expect(user_skill_rates_page).to have_content I18n.t('skills.favorite')
    end

    it 'selects one star in the boolean rate' do
      star = user_skill_rates_page.skill_rate1.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(1, 'click')
      expect(star[:class]).to include('selected')
    end

    it 'selects two stars in the boolean rate' do
      star = user_skill_rates_page.skill_rate2.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(2, 'click')
      expect(star[:class]).to include('selected')
    end

    it 'selects three stars in the boolean rate' do
      star = user_skill_rates_page.skill_rate3.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(3, 'click')
      expect(star[:class]).to include('selected')
    end

    it 'selects star in the range rate' do
      find('#ios-tab').click
      star = user_skill_rates_page.skill_rate1.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(1, 'click')
      expect(star[:class]).to include('selected')
    end
  end

  context 'when user have marked skills' do
    before do
      developer.user_skill_rates.update_all(rate: 2)
      developer.user_skill_rates.update_all(favorite: true)
      log_in_as developer
      user_skill_rates_page.load
    end

    it 'resets rating' do
      star = user_skill_rates_page.skill_rate2.first
      expect(star[:class]).to include('selected')
      page.execute_script "$('.skill__clear_rate').show()"
      user_skill_rates_page.clear_rate.first.click
      wait_for_ajax
      expect(star[:class]).to_not include('selected')
    end
  end
end
