require 'spec_helper'

describe 'Skill details page', js: true do
  let(:skill_details_page) { App.new.skill_details_page }

  let(:skill) { create :skill }
  let(:original_skill_details) do
    {
      name: skill.name,
      description: skill.description,
      rate_type: skill.rate_type,
      skill_category_id: skill.skill_category_id
    }
  end

  let!(:accepted_draft_skill) do
    create :draft_skill,
           :with_accepted_draft_status,
           original_skill_details: original_skill_details,
           skill: skill
  end

  let!(:declined_draft_skill) do
    create :draft_skill,
           :with_declined_draft_status,
           original_skill_details: original_skill_details,
           skill: skill
  end

  let!(:pending_draft_skill) do
    create :draft_skill,
           :with_update_draft_type,
           original_skill_details: original_skill_details,
           skill: skill
  end

  let(:admin_user) { create(:user, :admin) }

  before { log_in_as admin_user }

  context 'list of requests' do
    before { skill_details_page.load(id: skill.id) }

    scenario 'contains all change requests' do
      expect(skill_details_page.request_history.request.count).to eq 3
    end
  end
end
