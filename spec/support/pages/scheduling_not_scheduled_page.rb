class SchedulingNotScheduledPage < SitePrism::Page
  set_url '/scheduling/not_scheduled'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
