require 'spec_helper'

# TODO: require modification with scope
describe UsersForSkillQuery do
  let(:admin_user) { create(:user, :admin) }
  let(:technical_user) do
    create(:user, :technical, :with_primary_role, first_name: 'Bogdan', last_name: 'Mazur')
  end
  let(:technical_user_1) do
    create(:user, :technical, :with_primary_role, first_name: 'Janusz', last_name:  'Kowalski')
  end
  let(:user_2) { create(:user, first_name: 'Mirek', last_name:  'Nowak') }
  let(:skill) {  create(:skill, rate_type: 'range') }
  let(:team) { create(:team, user_id: team_leader.id) }
  let(:team_leader) do
    create(:user, first_name: 'Andrzej', last_name: 'Lewandowski')
  end
  let(:talent_position) do
    create(:position, user: create(:user), role: create(:talent_role))
  end
  let(:talent_user) { talent_position.user }

  let!(:user_skill_rate_favorite_rate_2) do
    create(
      :user_skill_rate,
      user: technical_user,
      skill: skill,
      rate: 2,
      favorite: true
    )
  end
  let!(:user_skill_rate_not_favorite_rate_2) do
    create(
      :user_skill_rate,
      user: technical_user_1,
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

  context 'for admin_user' do
    subject { UsersForSkillQuery.new(skill: skill, user: admin_user) }

    it_behaves_like 'returns correct results'
  end

  context 'for talent user' do
    subject { UsersForSkillQuery.new(skill: skill, user: talent_user) }

    it_behaves_like 'returns correct results'
  end

  context 'for team leader' do
    subject { UsersForSkillQuery.new(skill: skill, user: team_leader) }
    before { team.users << [technical_user, technical_user_1] }

    it 'returns correct ordered team users', :aggregate_failures do
      expect(results[0].user_skill_rate_id).to eq(
        user_skill_rate_favorite_rate_2.id
      )
      expect(results[1].user_skill_rate_id).to eq(
        user_skill_rate_not_favorite_rate_2.id
      )
      expect(results[2]).to be nil
    end
  end
end
