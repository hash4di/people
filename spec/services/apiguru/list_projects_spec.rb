require 'spec_helper'

describe Apiguru::ListProjects do
  describe '#call' do
    let(:projects_array) do
      [{ name: 'Table Crowd',
         product_owner: '123',
         product_owner_name: 'Mark',
         project_active: true },
       { name: 'bss',
         product_owner: '456',
         product_owner_name: 'Adam',
         project_active: true },
       { name: 'upfitness',
         product_owner: '678',
         product_owner_name: 'Jane',
         project_active: true },
       { name: 'old project',
         product_owner: '901',
         product_owner_name: 'John',
         project_active: false }]
    end

    subject { described_class.new.call }

    before do
      allow(Apiguru::Client)
        .to receive(:client)
        .and_return(projects_array)
    end

    it 'returns sorted list of active projects' do
      subject
      expect(subject).to eq ['bss', 'Table Crowd', 'upfitness']
    end
  end
end
