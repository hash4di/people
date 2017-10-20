class SchedulingToRotatePage < SitePrism::Page
  set_url '/scheduling/to_rotate'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
