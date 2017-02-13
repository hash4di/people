$ ->
  $tabDefault = $('.js-skills-tab a:first');
  $tab = $('.js-skills-tab .js-initial-skill-category a');

  $result = `$tab.length > 0 ? $tab : $tabDefault`;
  $result.tab('show');
