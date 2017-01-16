class UserSkillRatesPage < SitePrism::Page
  set_url '/user_skill_rates'

  elements :skill_rate1, '.glyphicon.skill__rate[data-rate="1"]'
  elements :skill_rate2, '.glyphicon.skill__rate[data-rate="2"]'
  elements :skill_rate3, '.glyphicon.skill__rate[data-rate="3"]'
  elements :skill_favorite, '.skill__favorite'
  elements :clear_rate, '.skill__clear_rate'
  elements :skill_note, '.skill__note'
  element :save_alert, '.messenger-message'
end
