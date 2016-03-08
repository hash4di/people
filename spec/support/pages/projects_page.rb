class ProjectsPage < SitePrism::Page
  set_url '/dashboard'

  section :menu, MenuSection, '.navbar-static-top'
  section :project_types, ProjectTypesSection, '.projects-types'
  section :project_filters, ProjectFiltersSection, '#filters'

  sections :projects, ProjectSection, '.project'

  element :new_project_button, '.btn.new-project-add'
end
