require 'spec_helper'

describe DraftSkillDecorator do
  subject { draft_skill.decorate }

  describe '#label_type_class' do
    context "when draft skill's type is 'create'" do
      let(:draft_skill) { build(:draft_skill, :with_create_draft_type) }

      it "returns 'label-primary'" do
        expect(subject.label_type_class).to eq 'label-primary'
      end
    end

    context "when draft skill's type is 'update'" do
      let(:draft_skill) { build(:draft_skill, :with_update_draft_type) }

      it "returns 'label-info'" do
        expect(subject.label_type_class).to eq 'label-info'
      end
    end

    context "when draft skill's type is 'delete'" do
      let(:draft_skill) { build(:draft_skill, :with_delete_draft_type) }

      it "returns 'label-danger'" do
        expect(subject.label_type_class).to eq 'label-danger'
      end
    end
  end
end
