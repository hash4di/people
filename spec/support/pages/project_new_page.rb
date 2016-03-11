class ProjectNewPage < SitePrism::Page
  set_url '/projects/new'

  section :menu, MenuSection, '.navbar-static-top'

  element :save_button, '.btn-success'
end
