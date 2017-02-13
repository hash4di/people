require 'spec_helper'

describe DraftSkills::Update do
  subject { described_class.new(draft_skill, draft_skill_params).call }
  let(:user) { create(:user) }

  shared_examples 'updates draft_skill' do
    it 'sets reviewer data' do
      subject
      expect(
        draft_skill.reviewer.id
      ).to eq draft_skill_params[:reviewer_id]
      expect(
        draft_skill.reviewer_explanation
      ).to eq draft_skill_params[:reviewer_explanation]
      expect(draft_skill.draft_status).to eq draft_status
    end
  end

  describe '#call' do
    context 'when params are valid' do
      let(:draft_skill_params) do
        {
          reviewer_explanation: 'Trust me, you want this.',
          reviewer_id: user.id,
          draft_status: draft_status
        }
      end

      context 'when draft_skill is create type' do
        let(:draft_skill) { create(:draft_skill, :with_create_draft_type) }

        context 'when draft_status equals accepted' do
          let(:draft_status) { 'accepted' }

          it 'creates skill' do
            expect { subject }.to change { Skill.count }.by(1)
          end

          it 'sets attributes form draft_skill to skill' do
            subject
            expect(draft_skill.skill.name).to eq draft_skill.name
            expect(draft_skill.skill.description).to eq draft_skill.description
            expect(draft_skill.skill.rate_type).to eq draft_skill.rate_type
            expect(draft_skill.skill.skill_category_id).to eq draft_skill.skill_category_id
          end

          include_examples 'updates draft_skill'
        end

        context 'when draft_status equals declined' do
          let(:draft_status) { 'declined' }

          it 'does not create new skill' do
            expect { subject }.to_not change { Skill.count }
          end

          it 'sets reviewer data on draft_skill' do
            subject
            expect(
              draft_skill.reviewer.id
            ).to eq draft_skill_params[:reviewer_id]
            expect(
              draft_skill.reviewer_explanation
            ).to eq draft_skill_params[:reviewer_explanation]
            expect(draft_skill.draft_status).to eq draft_status
          end
        end
      end

      context 'when draft_skill is update type' do
        let(:old_skill_category) { create(:skill_category) }
        let(:new_skill_category) { create(:skill_category) }
        let(:skill) do
          create(
            :skill,
            name: 'ruby',
            description: 'language',
            skill_category_id: old_skill_category.id,
            rate_type: 'boolean'
          )
        end
        let(:draft_skill) do
          create(
            :draft_skill,
            name: 'Ruby on Rails',
            description: 'Framework for Ruby',
            skill_category_id: new_skill_category.id,
            rate_type: 'range',
            draft_status: 'created',
            draft_type: 'update',
            skill_id: skill.id
          )
        end

        context 'when draft_status equals accepted' do
          let(:draft_status) { 'accepted' }

          include_examples 'updates draft_skill'

          it do expect { subject }.to change {
            skill.reload.name }.to(draft_skill.name)
          end
          it do
            expect { subject }.to change {
              skill.reload.description
            }.to(draft_skill.description)
          end
          it do
            expect { subject }.to change {
              skill.reload.rate_type
            }.to(draft_skill.rate_type)
          end
          it do
            expect { subject }.to change {
              skill.reload.skill_category_id
            }.to(draft_skill.skill_category_id)
          end
        end

        context 'when draft_status equals declined' do
          let(:draft_status) { 'declined' }

          it 'sets reviewer data on draft_skill' do
            subject
            expect(
              draft_skill.reviewer.id
            ).to eq draft_skill_params[:reviewer_id]
            expect(
              draft_skill.reviewer_explanation
            ).to eq draft_skill_params[:reviewer_explanation]
            expect(draft_skill.draft_status).to eq draft_status
          end

          it { expect { subject }.to_not change { skill.name } }
          it { expect { subject }.to_not change { skill.description } }
          it { expect { subject }.to_not change { skill.rate_type } }
          it { expect { subject }.to_not change { skill.skill_category_id } }
        end
      end
    end

    context 'when params are invalid' do
      let(:draft_skill_params) do
        {
          reviewer_explanation: '',
          reviewer_id: user.id,
          draft_status: 'accepted'
        }
      end
      let(:draft_skill) { create(:draft_skill) }

      it { expect(subject).to eq false }

      it 'sets errors on draft_skill' do
        expect(draft_skill.errors).to be_empty
        subject
        expect(
          draft_skill.errors[:reviewer_explanation]
        ).to include 'can\'t be blank'
      end
    end
  end
end
