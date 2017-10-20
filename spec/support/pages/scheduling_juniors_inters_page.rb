class SchedulingJuniorsIntersPage < SitePrism::Page
  set_url '/scheduling/juniors_and_interns'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
