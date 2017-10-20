class SchedulingBookedPage < SitePrism::Page
  set_url '/scheduling/booked'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
