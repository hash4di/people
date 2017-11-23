require 'spec_helper'

describe Skill do
  it { is_expected.to belong_to :skill_category }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :user_skill_rates }
  it { is_expected.to have_many :draft_skills }
  it { is_expected.to have_one :requested_change }
  it { is_expected.to have_one :requested_delete }

  it { is_expected.to  validate_presence_of :ref_name }
  it { is_expected.to  validate_uniqueness_of :ref_name }
  it { is_expected.to  validate_presence_of :name }
  it { is_expected.to  validate_presence_of :skill_category }
  it { is_expected.to  validate_presence_of :rate_type }
  it { is_expected.to  validate_inclusion_of(:rate_type).in_array(%w(boolean range)) }

  describe 'before validation behaviour' do
    subject { skill.valid? }
    let(:category) { create(:skill_category, name: 'backend') }
    let(:expected_ref_name) { 'backend_git' }

    context 'when skill category and name are set' do
      let(:skill) { build(:skill, name: 'git', skill_category: category) }

      it 'sets ref_name on skill' do
        expect(skill.ref_name).to be_nil
        subject
        expect(skill.ref_name).to eq expected_ref_name
      end
    end

    context 'when skill category is not set' do
      let(:skill) { build(:skill, name: 'foo', skill_category: nil) }
      let(:expected_errors) do
        ['Skill category and skill name have to be set.', 'can\'t be blank']
      end

      it 'add ref_name error' do
        expect(skill.errors).to be_empty
        subject
        expect(skill.errors.messages[:ref_name]).to eq expected_errors
      end
    end
  end

  describe 'uniques validation' do
    let(:category) { create(:skill_category) }
    let(:other_category) { create(:skill_category) }

    let!(:existing_skill) do
      create(:skill, name: 'foo', skill_category: category)
    end
    let!(:existing_skill2) do
      create(:skill, name: 'ROR', skill_category: other_category)
    end

    context 'when created' do
      let(:skill) { build(:skill, name: 'foo', skill_category: category) }

      it 'ensures uniques by name & category' do
        expect(skill.valid?).to be false
        expect(skill.errors.messages)
          .to eq ref_name: ['There is already skill with such name in this category']
      end
    end

    context 'when updated' do
      let(:persisted_skill) { create(:skill, name: 'ROR', skill_category: category) }

      context 'with existing combination of name and category' do

        it 'is invalid' do
          persisted_skill.update(name: 'foo')
          expect(persisted_skill.valid?).to be false
          expect(persisted_skill.errors.messages)
            .to eq ref_name: ['There is already skill with such name in this category']
        end

        it 'is invalid' do
          persisted_skill.update(skill_category: other_category)
          expect(persisted_skill.valid?).to be false
          expect(persisted_skill.errors.messages)
            .to eq ref_name: ['There is already skill with such name in this category']
        end
      end

      context 'with new combination of name and category' do
        before { persisted_skill.update(name: 'foo', skill_category: other_category) }

        it 'is valid' do
          expect(persisted_skill.valid?).to be true
        end
      end

      context 'allows update of other attributes' do

        it 'is valid' do
          existing_skill.update(rate_type: 'boolean', description: 'description')
          expect(existing_skill.valid?).to be true
        end
      end
    end
  end

  context 'when destroyed' do
    let!(:skill) do
      FactoryGirl.create(:skill, :with_awaiting_create_request, :with_user_skill_rate)
    end

    subject { skill.destroy }

    context 'has been successfully deleted from salesforce' do
      before { allow(skill).to receive(:delete_from_sf!) { true } }

      it 'destroys associated UserSkillRates' do
        expect { subject }.to change { UserSkillRate.count }.from(1).to(0)
      end

      it 'destroys associated DraftSkills' do
        expect { subject }.to change { DraftSkill.count }.from(1).to(0)
      end
    end

    context 'has not been successfully deleted from salesforce' do
      before { allow(skill).to receive(:delete_from_sf!) { false } }

      it 'does not destroy associated UserSkillRates' do
        expect { subject }.to_not change { UserSkillRate.count }
      end

      it 'does not destroy associated DraftSkills' do
        expect { subject }.to_not change { DraftSkill.count }
      end
    end
  end
end
