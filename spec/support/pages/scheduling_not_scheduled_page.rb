class SchedulingNotScheduledPage < SitePrism::Page
  set_url '/scheduling/not_scheduled'

  sections :user_rows, '.scheduled-users tbody tr' do
    element :current_projects, '.projects-region'
  end
end
