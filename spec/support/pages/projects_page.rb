class ProjectsPage < SitePrism::Page
  set_url '/dashboard'

  element :active_tab, '.projects-types li.active'
  element :potential_tab, '.projects-types li.potential'
  element :archived_tab, '.projects-types li.archived'

  elements :archive_icons, '.project-name .action a.archive'
  elements :unarchive_icons, '.project-name .action a.unarchive'
  elements :member_dropdowns, '.project-details .Select-placeholder'
  elements :time_from_elements, '.time-from time'
  elements :time_to_elements, '.time-to time'
  elements :billable_counters, '.billable .count'
  elements :non_billable_counters, '.non-billable .count'
end
