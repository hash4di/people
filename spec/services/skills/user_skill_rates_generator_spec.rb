require 'spec_helper'

describe Skills::UserSkillRatesGenerator do
  subject { described_class.new }
  let!(:user) { create :user }
  let!(:skill1) { create :skill }
  let!(:skill2) { create :skill }

  describe '.generate_all_for_user' do
    it 'creates all skill rates for single user' do
      expect { subject.generate_all_for_user(user_id: user.id) }.to change { user.skills.count }.from(0).to(2)
    end
  end

  describe '.generate_single_for_all_users' do
    it 'creates one skill rate for all users' do
      expect { subject.generate_single_for_all_users(skill_id: skill1.id) }.to change { skill1.users.count }.from(0).to(1)
    end
  end
end
