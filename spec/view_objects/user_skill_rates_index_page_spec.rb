require 'spec_helper'

describe UserSkillRatesIndexPage do
  let(:user) { create(:developer_in_project) }
  let(:role) { user.roles.first }
  let!(:skill_category) { create(:skill_category) }

  subject { UserSkillRatesIndexPage.new(user: user) }

  before do
    user.update_attribute('primary_role', role)
    skill_category.roles << role
  end

  describe '#initial_skill_category' do
    it 'returns proper class' do
      expect(subject.initial_skill_category(skill_category.name)).to be_truthy
    end
  end
end
