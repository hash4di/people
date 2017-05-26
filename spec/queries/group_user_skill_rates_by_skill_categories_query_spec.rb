require 'spec_helper'

describe GroupUserSkillRatesBySkillCategoriesQuery do
  let(:user) { create(:user) }
  let(:skill_category_backend) { create(:skill_category, name: 'backend') }
  let(:skill_category_frontend) { create(:skill_category, name: 'frontend') }
  let(:skill_backend) { create(:skill, skill_category: skill_category_backend) }
  let(:skill_frontend) { create(:skill, skill_category: skill_category_frontend) }
  let!(:user_skill_rate_backend) { create(:user_skill_rate, user: user, skill: skill_backend ) }
  let!(:user_skill_rate_frontend) { create(:user_skill_rate, user: user, skill: skill_frontend ) }
  let(:result_object) { subject.results['backend'].first }

  let(:expected_results) do
    {
      "backend" => [user_skill_rate_backend],
      "frontend" => [user_skill_rate_frontend]
    }
  end

  subject { GroupUserSkillRatesBySkillCategoriesQuery.new(user) }


  it "returns all user_skill_rates grouped by categories" do
    expect(subject.results).to eq(expected_results)
  end

  it "returns user_skill_rate with requried attributes" do
    expect(result_object.serializable_hash).to include(
      'name' => skill_backend.name,
      'description' => skill_backend.description,
      'rate_type' => skill_backend.rate_type,
      'category' => skill_category_backend.name,
      'skill_id' => user_skill_rate_backend.skill_id,
      'user_id' => user_skill_rate_backend.user_id,
      'rate' => user_skill_rate_backend.rate,
      'note' => user_skill_rate_backend.note,
      'favorite' => user_skill_rate_backend.favorite
    )
  end
end
