class UserRowSection < SitePrism::Section
  section :profile, '.profile' do
    element :name, '.name'
  end
  section :current_project, '.projects-region' do
    element :name, '.project-name'
    element :internal_label, '.project-label', text: 'INTERNAL'
    element :nonbillable_sign, '.project-label', text: 'NON-BILLABLE'
  end
  section :next_project, '.next_projects-region' do
    element :name, '.project-name'
    element :internal_label, '.project-label', text: 'INTERNAL'
  end
  section :booked_project, '.booked_projects-region' do
    element :name, '.project-name'
  end
end
