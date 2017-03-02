require 'spec_helper'

describe SavePosition do
  let(:user) { create(:user) }
  let(:position) { build(:position, user: user) }

  subject { described_class.new(position).call }

  context 'when position is valid' do
    it 'creates a new position' do
      expect { subject }.to change(Position, :count).by 1
    end

    it 'returns true' do
      expect(subject).to be true
    end

    context 'when position is primary' do
      let(:position) { build(:position, :primary, user: user) }

      it 'sets new primary_role for user' do
        expect { subject }.to change { user.primary_role }.to(position.role)
      end
    end
  end

  context 'when position is invalid' do
    before { position.user = nil }

    it 'does not create a new position' do
      expect { subject }.not_to change(Position, :count)
    end

    it 'returns false' do
      expect(subject).to be false
    end
  end
end
