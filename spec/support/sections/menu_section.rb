class MenuSection < SitePrism::Section
  element :logo, '.navbar-brand'
  element :scheduling, 'ul.nav.navbar-nav li.scheduling'
  element :users, 'ul.nav.navbar-nav li.users'
  element :projects, 'ul.nav.navbar-nav li.dashboard'
  element :teams, 'ul.nav.navbar-nav li.teams'
end
