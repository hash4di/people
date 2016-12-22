require 'spec_helper'

# TODO: require modification with scope
describe UsersForSkillQuery do
  subject { UsersForSkillQuery.new(skill: skill, user: admin_user) }
  let(:admin_user) { create(:user, :admin) }

  let(:user) { create(:user, first_name: 'Bogdan', last_name: 'Mazur') }
  let(:user_1) { create(:user, first_name: 'Jaunsz', last_name:  'Kowalski') }
  let(:user_2) { create(:user, first_name: 'Mirek', last_name:  'Nowak') }
  let(:skill) {  create(:skill, rate_type: 'range') }

  let!(:user_skill_rate_favorite_rate_2) do
    create(
      :user_skill_rate,
      user: user,
      skill: skill,
      rate: 2,
      favorite: true
    )
  end
  let!(:user_skill_rate_not_favorite_rate_2) do
    create(
      :user_skill_rate,
      user: user_1,
      skill: skill,
      rate: 2,
      favorite: false
    )
  end
  let!(:user_skill_rate_favorite_rate_1) do
    create(
      :user_skill_rate,
      user: user_2,
      skill: skill,
      rate: 1,
      favorite: true
    )
  end

  let(:results) { subject.results }
  let(:result_object) { subject.results.first }

  it 'returns correct ordered users', :aggregate_failures do
    expect(results[0].user_skill_rate_id).to eq(
      user_skill_rate_favorite_rate_2.id
    )
    expect(results[1].user_skill_rate_id).to eq(
      user_skill_rate_not_favorite_rate_2.id
    )
    expect(results[2].user_skill_rate_id).to eq(
      user_skill_rate_favorite_rate_1.id
    )
  end

  it 'returns user with requried attributes', :aggregate_failures do
    expect(result_object.serializable_hash).to include(
      'user_skill_rate_id' => user_skill_rate_favorite_rate_2.id,
      'rate' => user_skill_rate_favorite_rate_2.rate,
      'favorite' => user_skill_rate_favorite_rate_2.favorite,
      'user_id' => user_skill_rate_favorite_rate_2.user_id,
      'first_name' => user_skill_rate_favorite_rate_2.user.first_name,
      'last_name' => user_skill_rate_favorite_rate_2.user.last_name
    )
  end
end
