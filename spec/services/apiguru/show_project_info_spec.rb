require 'spec_helper'

describe Apiguru::ShowProjectInfo do
  describe '#call' do
    let(:projects_array) do
      [{ name: 'Table Crowd',
         product_owner: '123' },
       { name: 'bss',
         product_owner: '456' }]
    end

    subject { described_class.new(name: 'bss').call }

    before do
      allow(Apiguru::Client)
        .to receive(:client)
        .and_return(projects_array)
    end

    it 'returns sorted list of active projects' do
      subject
      expect(subject).to eq({ name: 'bss',
                              product_owner: '456' })
    end
  end
end
