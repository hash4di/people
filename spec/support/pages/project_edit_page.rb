class ProjectEditPage < SitePrism::Page
  set_url '/projects{/project_id}/edit'

  section :menu, MenuSection, '.navbar-static-top'

  element :save_button, '.btn-success'
end
