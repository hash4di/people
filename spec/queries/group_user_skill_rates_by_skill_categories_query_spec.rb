require 'spec_helper'

describe GroupUserSkillRatesBySkillCategoriesQuery do
  let(:user) { create(:user) }
  subject { GroupUserSkillRatesBySkillCategoriesQuery.new(user) }

  let(:skill_category_backend) { create(:skill_category, name: 'backend') }
  let(:skill_category_frontend) { create(:skill_category, name: 'frontend') }
  let(:skill_backend) { create(:skill, skill_category: skill_category_backend) }
  let(:skill_frontend) { create(:skill, skill_category: skill_category_frontend) }
  let!(:user_skill_rate_backend) { create(:user_skill_rate, user: user, skill: skill_backend ) }
  let!(:user_skill_rate_frontend) { create(:user_skill_rate, user: user, skill: skill_frontend ) }

  let(:expected_results) do
    {
      "backend" => [user_skill_rate_backend],
      "frontend" => [user_skill_rate_frontend]
    }
  end

  let(:result_object) { subject.results['backend'].first }

  it "returns all user_skill_rates grouped by categories" do
    expect(subject.results).to eq(expected_results)
  end

  it "returns user_skill_rate with requried attributes" do
    expect(result_object.name).to eq(skill_backend.name)
    expect(result_object.description).to eq(skill_backend.description)
    expect(result_object.rate_type).to eq(skill_backend.rate_type)
    expect(result_object.category).to eq(skill_category_backend.name)
    expect(result_object.skill_id).to eq(user_skill_rate_backend.skill_id)
    expect(result_object.user_id).to eq(user_skill_rate_backend.user_id)
    expect(result_object.rate).to eq(user_skill_rate_backend.rate)
    expect(result_object.note).to eq(user_skill_rate_backend.note)
    expect(result_object.favorite).to eq(user_skill_rate_backend.favorite)
  end
end
