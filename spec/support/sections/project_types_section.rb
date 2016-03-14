class ProjectTypesSection < SitePrism::Section
  element :active_tab, '.projects-types li.active'
  element :potential_tab, '.projects-types li.potential'
  element :archived_tab, '.projects-types li.archived'
end
