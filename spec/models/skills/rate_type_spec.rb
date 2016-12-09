require 'spec_helper'

describe Skills::RateType do
  describe '.stringified_types' do
    subject { described_class.stringified_types }

    it 'returns array with all types' do
      is_expected.to eq(%w(boolean range))
    end
  end

  describe '#expected_range' do
    subject { rate_type.expected_range }

    context 'when rate_type is invalid value' do
      let(:rate_type) { described_class.new(type: :invalid_type) }

      it 'returns null object' do
        is_expected.to be_a(::NullObjects::NullObject)
      end
    end

    context 'when rate_type is valid value' do
      let(:rate_type) { described_class.new(type: :range) }

      it 'returns range' do
        is_expected.to eq(0..3)
      end
    end
  end
end
