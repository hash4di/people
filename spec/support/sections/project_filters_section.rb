class ProjectFiltersSection < SitePrism::Section
  element :roles_filter, '.filters .filter.roles'
  element :projects_filter, '.filters .filter.projects'
  element :users_filter, '.filters .filter.users'
  element :ending_checkbox, '.checkboxes #highlight-ending'
  element :next_checkbox, '.checkboxes #show-next'
end
