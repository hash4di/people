require 'spec_helper'

describe ::NullObjects::NullObject do
  describe 'when method missing' do
    it 'returns nil' do
      result = subject.non_existing_method_with_args(0, nil, [])
      expect(result).to eq(nil)
    end
  end
end
