jQuery ->
  $tabDefault = $('.js-skills-tab a:first')
  $tab = $('.js-skills-tab .js-initial-skill-category a')

  $result = if $tab.length > 0 then $tab else $tabDefault
  $result.tab('show')
