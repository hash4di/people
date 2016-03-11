class ProjectEditPage < SitePrism::Page
  set_url '/projects{/project_id}/edit'

  element :save_button, '.btn-success'
end
