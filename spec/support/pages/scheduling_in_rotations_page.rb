class SchedulingInRotationsPage < SitePrism::Page
  set_url '/scheduling/with_rotations_in_progress'

  sections :user_rows, UserRowSection, '.scheduled-users tbody tr'
end
