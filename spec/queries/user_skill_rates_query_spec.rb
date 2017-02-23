require 'spec_helper'

describe UserSkillRatesQuery do
  let(:user) { create(:user) }
  subject { UserSkillRatesQuery.new(user) }

  let(:skill_category_backend) { create(:skill_category, name: 'backend') }
  let(:skill_category_frontend) { create(:skill_category, name: 'frontend') }
  let(:skill_backend) { create(:skill, skill_category: skill_category_backend) }
  let(:skill_frontend) { create(:skill, skill_category: skill_category_frontend) }
  let!(:user_skill_rate_backend) do
    create(
      :user_skill_rate,
      user: user,
      skill: skill_backend,
      rate: 1
      )
  end
  let!(:user_skill_rate_frontend) do
    create(
      :user_skill_rate,
      user: user,
      skill: skill_frontend,
      rate: 0
    )
  end

  describe '#results_by_categories' do
    let(:expected_results) do
      {
        "backend" => [user_skill_rate_backend],
        "frontend" => [user_skill_rate_frontend]
      }
    end

    let(:result_object) { subject.results_by_categories['backend'].first }

    it "returns all user_skill_rates grouped by categories" do
      expect(subject.results_by_categories).to eq(expected_results)
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

  describe '#results_for_category' do
    let(:expected_results){ [user_skill_rate_backend] }

    let(:result_object) do
      subject.results_for_category(skill_category_backend.name)
    end

    it "returns all user_skill_rates grouped by categories" do
      expect(
        subject.results_for_category(skill_category_backend.name)
      ).to eq(expected_results)
    end

    it "returns user_skill_rate with requried attributes" do
      expect(result_object.first.serializable_hash).to include(
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

  describe '#rated_skills' do
    let(:expected_results){ { "backend" => [user_skill_rate_backend] } }
    let(:result_object) { subject.rated_skills }

    it 'returns only rated user_skill_rate' do
      expect(result_object).to eq(expected_results)
    end
  end
end
