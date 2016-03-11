class ProjectShowPage < SitePrism::Page
  set_url '/projects{/project_id}'

  section :menu, MenuSection, '.navbar-static-top'
end
