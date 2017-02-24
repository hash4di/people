require 'spec_helper'

describe DraftSkills::Create do
  subject do
    described_class.new(
      params: params,
      type: draft_type,
      user: user,
      skill: skill
    )
  end
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
  let(:skill) { create(:skill) }
  let(:draft_type) { 'create' }
  let(:draft_status) { 'created' }

  describe '#initialize' do
    context 'when type is create' do
      let(:draft_type) { 'create' }
      let(:expected_draft_skill) { subject.draft_skill }
      let(:skill) { nil }

      it 'initializez draft_skill with correct attributes' do
        expect(expected_draft_skill).to be_present
        expect(expected_draft_skill.new_record?).to be_present
        expect(expected_draft_skill.new_record?).to eq(true)
        expect(expected_draft_skill.name).to eq(params[:name])
        expect(expected_draft_skill.description).to eq(params[:description])
        expect(expected_draft_skill.rate_type).to eq(params[:rate_type])
        expect(
          expected_draft_skill.skill_category_id
        ).to eq(params[:skill_category_id])
        expect(
          expected_draft_skill.requester_explanation
        ).to eq(params[:requester_explanation])

        expect(expected_draft_skill.requester_id).to eq(user.id)
        expect(expected_draft_skill.skill_id).to be_nil
        expect(expected_draft_skill.draft_type).to eq(draft_type)
        expect(expected_draft_skill.draft_status).to eq(draft_status)
      end
    end
    context 'when type is update' do
      let(:draft_type) { 'update' }
      let(:expected_draft_skill) { subject.draft_skill }

      it 'initializes draft_skill with correct attributes' do
        expect(expected_draft_skill).to be_present
        expect(expected_draft_skill.new_record?).to eq(true)
        expect(expected_draft_skill.name).to eq(params[:name])
        expect(expected_draft_skill.description).to eq(params[:description])
        expect(expected_draft_skill.rate_type).to eq(params[:rate_type])
        expect(
          expected_draft_skill.skill_category_id
        ).to eq(params[:skill_category_id])
        expect(
          expected_draft_skill.requester_explanation
        ).to eq(params[:requester_explanation])

        expect(expected_draft_skill.requester_id).to eq(user.id)
        expect(expected_draft_skill.skill_id).to eq(skill.id)
        expect(expected_draft_skill.draft_type).to eq(draft_type)
        expect(expected_draft_skill.draft_status).to eq(draft_status)


        expect(
          expected_draft_skill.original_skill_details.name
        ).to eq(expected_draft_skill.skill.name)
        expect(
          expected_draft_skill.original_skill_details.description
        ).to eq(expected_draft_skill.skill.description)
        expect(
          expected_draft_skill.original_skill_details.rate_type
        ).to eq(expected_draft_skill.skill.rate_type)
        expect(
          expected_draft_skill.original_skill_details.skill_category_id
        ).to eq(expected_draft_skill.skill.skill_category_id)
      end
    end
  end

  describe '#valid?' do
    context 'when is valid' do
      it { expect(subject.valid?).to eq(true) }
    end
    context 'when is invalid' do
      let(:params) do
        {
          name: 'Git',
          description: 'Github tool',
          rate_type: 'boolean',
          skill_category_id: skill_category.id,
          requester_explanation: ''
        }
      end

      it { expect(subject.valid?).to eq(false) }
    end
  end

  describe '#errors' do
    context 'when is valid' do
      it { expect(subject.errors).to be_blank }
    end
    context 'when is invalid' do
      let(:params) do
        {
          name: 'Git',
          description: 'Github tool',
          rate_type: 'boolean',
          skill_category_id: skill_category.id,
          requester_explanation: ''
        }
      end
      it { expect(subject.errors).to_not be_blank }
      it { expect(subject.errors[:requester_explanation]).to include('can\'t be blank') }
    end
  end

  describe 'save!' do
    context 'when is valid' do
      it 'saves draft_skill object' do
        expect { subject.save! }.to change { subject.draft_skill.new_record? }.from(true).to(false)
      end
    end
    context 'when is invalid' do
      let(:params) do
        {
          name: 'Git',
          description: 'Github tool',
          rate_type: 'boolean',
          skill_category_id: skill_category.id,
          requester_explanation: ''
        }
      end
      it 'does not save draft_skill object' do
        expect { subject.save! }.to_not change { subject.draft_skill.new_record? }
      end
    end
  end
end
