require 'spec_helper'

describe Skills::ChangeRequester do
  subject { described_class.new(skill: skill, params: params, user: user) }

  shared_examples 'when skill is invalid' do
    context 'when skill is invalid' do
      let(:params) do
        {
          name: 'Git',
          description: '',
          rate_type: 'boolean',
          skill_category_id: skill_category.id,
          requester_explanation: 'Everyone should know this'
        }
      end

      it { expect(request_result).to eq(false) }
      it 'does not create draft_skill' do
        expect { request_result }.to_not change { DraftSkill.count }
      end
    end
  end

  shared_examples 'when draft_skill is invalid' do
    context 'when draft_skill is invalid' do
      let(:params) do
        {
          name: 'Git',
          description: 'Github tool',
          rate_type: 'boolean',
          skill_category_id: skill_category.id,
          requester_explanation: ''
        }
      end

      it { expect(request_result).to eq(false) }
      it 'does not create skill' do
        expect { request_result }.to_not change { Skill.count }
      end
      it 'does not create draft_skill' do
        expect { request_result }.to_not change { DraftSkill.count }
      end
      it 'sets errors on skill' do
        request_result
        expect(skill.errors[:requester_explanation]).to include('can\'t be blank')
      end
    end
  end

  describe '#request' do
    let(:user) { create(:user) }
    let(:skill_category) { create(:skill_category) }
    let(:params) do
      {
        name: 'Git',
        description: 'Github tool',
        rate_type: 'boolean',
        skill_category_id: skill_category.id,
        requester_explanation: 'Everyone should know this'
      }
    end
    let(:request_result) { subject.request(type: request_type) }

    context 'when type is invalid' do
      let(:request_type) { 'destroy' }
      let(:skill) { build(:skill) }

      it 'raises error' do
        expect { request_result }.to raise_error(
          "You can select only two types of request: #{DraftSkill::TYPES}"
        )
      end
    end

    context 'when type is valid' do
      context 'when type is create' do
        let(:request_type) { 'create' }
        let(:skill) { build(:skill) }

        include_examples 'when skill is invalid'
        include_examples 'when draft_skill is invalid'

        context 'when skill and draft_skill are valid' do
          it 'creates draft_skill' do
            expect { request_result }.to change { DraftSkill.count }.by(1)
            expect(subject.draft_skill.draft_type).to eq(request_type)
          end
          it 'does not create skill' do
            expect { request_result }.to_not change { Skill.count }
          end
        end
      end
    end

    context 'when type is update' do
      let(:request_type) { 'update' }
      let!(:skill) { create(:skill) }

      include_examples 'when skill is invalid'
      include_examples 'when draft_skill is invalid'

      context 'when skill and draft_skill are valid' do
        it 'creates draft_skill' do
          expect { request_result }.to change { DraftSkill.count }.by(1)
          expect(subject.draft_skill.draft_type).to eq(request_type)
        end
        it 'does not update skill' do
          expect { subject }.to_not change { skill.name }
          expect { subject }.to_not change { skill.description }
          expect { subject }.to_not change { skill.rate_type }
          expect { subject }.to_not change { skill.skill_category_id }
        end
      end
    end
  end
end
