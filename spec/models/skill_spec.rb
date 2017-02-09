require 'spec_helper'

describe Skill do
  it { is_expected.to belong_to :skill_category }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :user_skill_rates }
  it { is_expected.to have_many :draft_skills }
  it { is_expected.to have_one :requested_change }

  it { is_expected.to  validate_presence_of :ref_name }
  it { is_expected.to  validate_uniqueness_of :ref_name }
  it { is_expected.to  validate_presence_of :name }
  it { is_expected.to  validate_presence_of :skill_category }
  it { is_expected.to  validate_presence_of :rate_type }
  it { is_expected.to  validate_inclusion_of(:rate_type).in_array(%w(boolean range)) }

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
          .to eq :'ref_name' => ['There is already skill with such name in this category']
      end
    end

    context 'when updated' do
      let(:persisted_skill) { create(:skill, name: 'ROR', skill_category: category) }

      context 'with existing combination of name and category' do

        it 'is invalid' do
          persisted_skill.update(name: 'foo')
          expect(persisted_skill.valid?).to be false
          expect(persisted_skill.errors.messages)
            .to eq :'ref_name' => ['There is already skill with such name in this category']
        end

        it 'is invalid' do
          persisted_skill.update(skill_category: other_category)
          expect(persisted_skill.valid?).to be false
          expect(persisted_skill.errors.messages)
            .to eq :'ref_name' => ['There is already skill with such name in this category']
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
end
