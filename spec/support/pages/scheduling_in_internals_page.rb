class SchedulingInInternalsPage < SitePrism::Page
  set_url '/scheduling/in_internals'

  sections :user_rows, '.scheduled-users tbody tr' do
    elements :internal_label, '.project-label', text: 'INTERNAL'
  end
end
