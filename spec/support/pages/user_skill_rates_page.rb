class UserSkillRatesPage < SitePrism::Page
  set_url '/user_skill_rates'

  elements :skill_rate1, '.glyphicon.skill__rate[data-rate="1"]'
  elements :skill_rate2, '.glyphicon.skill__rate[data-rate="2"]'
  elements :skill_rate3, '.glyphicon.skill__rate[data-rate="3"]'
  elements :skill__favorite, '.skill__favorite'
end
