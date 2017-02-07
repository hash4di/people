require 'spec_helper'

describe 'User skill rates page', js: true do
  let(:user_skill_rates_page) { App.new.user_skill_rates_page }

  let(:skill_category_1) { create :skill_category, name: 'backend' }
  let(:skill_category_2) { create :skill_category, name: 'ios' }

  let(:skills_range) { create_list :skill, 2, :with_range_rate_type, skill_category: skill_category_1 }
  let(:skills_boolean) { create_list :skill, 2, :with_boolean_rate_type, skill_category: skill_category_2 }

  let!(:developer) { create(:user, :developer, skills: skills_range + skills_boolean) }

  describe "TIMEBOMB for fixing this test" do
    it { expect(Date.today).to be < Date.parse("10/02/2017") }
  end

  context 'when user does not have any marked skills' do
    before do
      log_in_as developer
      user_skill_rates_page.load
    end

    def skill_rate_trigger(num, event_name)
      page.execute_script "$('.glyphicon.skill__rate[data-rate=\"#{num}\"]:first').trigger('#{event_name}')"
    end

    xit 'checks tooltips' do
      3.times do |num|
        skill_rate_trigger(num + 1, 'mouseover')
        expect(user_skill_rates_page).to have_content I18n.t('skills.rating.range')[num + 1]
        skill_rate_trigger(num + 1, 'blur')
      end
      page.execute_script "$('.skill__favorite').trigger('mouseover')"
      expect(user_skill_rates_page).to have_content I18n.t('skills.favorite')
    end

    xit 'selects one star in the range rate' do
      star = user_skill_rates_page.skill_rate1.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(1, 'click')
      expect(star[:class]).to include('selected')
    end

    xit 'selects two stars in the range rate' do
      star = user_skill_rates_page.skill_rate2.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(2, 'click')
      expect(star[:class]).to include('selected')
    end

    xit 'selects three stars in the range rate' do
      star = user_skill_rates_page.skill_rate3.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(3, 'click')
      expect(star[:class]).to include('selected')
    end

    xit 'selects star in the boolean rate' do
      find('#ios-tab').click
      star = user_skill_rates_page.skill_rate1.first
      expect(star[:class]).to_not include('selected')
      skill_rate_trigger(1, 'click')
      expect(star[:class]).to include('selected')
    end

    xit 'selects favourite skill' do
      heart = user_skill_rates_page.skill_favorite.first
      expect(heart[:class]).to_not include('selected')
      user_skill_rates_page.skill_favorite.first.click
      expect(heart[:class]).to include('selected')
    end

    xit 'adds note' do
      skill_rate = developer.user_skill_rates.first
      expect do
        user_skill_rates_page.skill_note.first.set 'test note'
        user_skill_rates_page.wait_for_save_alert
      end.to change { skill_rate.reload.note }.from('').to('test note')
    end
  end

  context 'when user have marked skills' do
    before do
      range_skills_ids = skills_range.map(&:id)
      developer.user_skill_rates.where(skill_id: range_skills_ids).update_all(rate: 2)
      developer.user_skill_rates.update_all(favorite: true)
      log_in_as developer
      user_skill_rates_page.load
    end

    xit 'resets rating' do
      find('#backend-tab').click
      user_skill_rates_page.wait_for_two_starts
      star = user_skill_rates_page.skill_rate2.first
      expect(star[:class]).to include('selected')
      page.execute_script "$('.skill__clear_rate').show()"
      user_skill_rates_page.clear_rate.first.click
      wait_for_ajax
      expect(star[:class]).to_not include('selected')
    end

    xit 'deselects favourite skill' do
      heart = user_skill_rates_page.skill_favorite.first
      expect(heart[:class]).to include('selected')
      user_skill_rates_page.skill_favorite.first.click
      expect(heart[:class]).to_not include('selected')
    end
  end
end
