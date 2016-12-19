require 'spec_helper'

describe UserSkillRate do
  it { is_expected.to belong_to :skill }
  it { is_expected.to belong_to :user }

  describe 'validations' do
    it { is_expected.to  validate_presence_of :skill }
    it { is_expected.to  validate_presence_of :user }

    describe 'uniqueness of :skill in given :user scope' do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:skill) { create(:skill) }
      let(:another_skill) { create(:skill) }
      let!(:user_skill_rate) { create(:user_skill_rate, user: user, skill: skill) }

      subject { another_user_skill_rate.valid? }

      before { subject }

      context 'when skill is already assigned to user' do
        let!(:another_user_skill_rate) { build(:user_skill_rate, user: user, skill: skill) }
        let(:error_message) { another_user_skill_rate.errors.full_messages }

        it 'raises validation error' do
          expect(error_message).to include('Skill has already been taken')
        end
      end

      context 'when different skills are assigned to the same user' do
        let!(:another_user_skill_rate) { build(:user_skill_rate, user: user, skill: another_skill) }
        let(:errors_count) { another_user_skill_rate.errors.count }

        it 'raises validation error' do
          expect(errors_count).to eq(0)
        end
      end

      context 'when different users are assigned to the same skill' do
        let!(:another_user_skill_rate) { build(:user_skill_rate, user: another_user, skill: skill) }
        let(:errors_count) { another_user_skill_rate.errors.count }

        it 'raises validation error' do
          expect(errors_count).to eq(0)
        end
      end
    end
  end

  subject { build :user_skill_rate }

  describe '#rate' do
    subject { described_class.new }
    it 'equals 0 by default' do
      expect(subject.rate).to eq 0
    end
  end
end
