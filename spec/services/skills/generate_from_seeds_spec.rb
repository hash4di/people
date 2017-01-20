require 'spec_helper'

describe Skills::GenerateFromSeeds do
  subject { described_class.call }

  describe '.call' do
    context 'when SKILLS_AND_CATEGORIES is not empty' do
      let(:expected_message) { '2 skills was modificated.' }

      before do
        SKILLS_AND_CATEGORIES = [
          {
            ref_name: 'backend_ruby-on-rails',
            name: 'Ruby on Rails',
            rating: 'int',
            description: 'Rails.',
            category: 'backend'
          },
          {
            ref_name: 'backend_sinatra',
            name: 'Sinatra',
            rating: 'boolean',
            description: 'Sinatra.',
            category: 'backend'
          }
        ]
      end

      it 'creates one new category' do
        expect { subject }.to change { SkillCategory.count }.from(0).to(1)
      end

      it 'creates two new skills' do
        expect { subject }.to change { Skill.count }.from(0).to(2)
      end

      it 'returns correct message' do
        expect(subject).to eq(expected_message)
      end
    end

    context 'when SKILLS_AND_CATEGORIES is empty' do
      before { SKILLS_AND_CATEGORIES = [] }

      it 'raises error' do
        expect { subject }.to raise_error('Please run `rake skills:generate_seeds` first')
      end
    end
  end
end
