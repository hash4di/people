class SchedulingInInternalsPage < SitePrism::Page
  set_url '/scheduling/in_internals'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
