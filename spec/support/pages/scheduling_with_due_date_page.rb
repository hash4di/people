class SchedulingProjectsWithDueDatePage < SitePrism::Page
  set_url '/scheduling/in_commercial_projects_with_due_date'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
