require 'spec_helper'

describe Skill do
  it { is_expected.to belong_to :skill_category }
  it { is_expected.to have_many :users }
  it { is_expected.to have_many :user_skill_rates }

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

    it 'ensurs uniques by name & category for new_record' do
      skill = build(:skill, name: 'foo', skill_category: category)
      expect(skill.valid?).to be false
      expect(skill.errors.messages)
        .to eq :'name & skill_category' => ['must be uniq']
    end

    it 'ensurs uniques by name & category when skill is updated' do
      persisted_skill = create(:skill, name: 'ROR', skill_category: category)
      persisted_skill.update(name: 'foo')
      expect(persisted_skill.valid?).to be false
      expect(persisted_skill.errors.messages)
        .to eq :'name & skill_category' => ['must be uniq']
      persisted_skill.reload
      persisted_skill.update(name: 'foo', skill_category: other_category)
      expect(persisted_skill.valid?).to be true
      persisted_skill.update(skill_category: category)
      expect(persisted_skill.valid?).to be false
      expect(persisted_skill.errors.messages)
        .to eq :'name & skill_category' => ['must be uniq']
    end

    it 'allows update of other attributes' do
      existing_skill.update(rate_type: 'boolean', description: 'description')
      expect(existing_skill.valid?).to be true
    end
  end
end
