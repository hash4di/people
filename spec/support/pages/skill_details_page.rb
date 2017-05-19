class SkillDetailsPage < SitePrism::Page
  set_url '/skills/{id}'

  section :request_history, '.request-history' do
    sections :request, '.request-row' do
      element :type_cell, 'th:nth-child(1)'
      element :status_cell, 'th:nth-child(2)'
      element :request_time_cell, 'th:nth-child(3)'
      element :review_time_cell, 'th:nth-child(4)'
      element :status_cell, 'th:nth-child(2)'
      element :details_button, '.request-details'
      element :review_button, '.review-request'
    end
  end
end
