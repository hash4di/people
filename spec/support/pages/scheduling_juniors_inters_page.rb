class SchedulingJuniorsIntersPage < SitePrism::Page
  set_url '/scheduling/juniors_and_interns'

  elements :user_rows, '.scheduled-users tbody tr'
  elements :nonbillable_signs, '.project-label', text: 'non-billable'
end
