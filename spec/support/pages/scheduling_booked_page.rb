class SchedulingBookedPage < SitePrism::Page
  set_url '/scheduling/booked'

  sections :user_rows, '.scheduled-users tbody tr' do
    element :booking_projects, '.booked_projects-region'
  end
end
