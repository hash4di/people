class SchedulingUnavailablePage < SitePrism::Page
  set_url '/scheduling/unavailable'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
