require 'spec_helper'

describe Api::V3::TeamSerializer do
  let(:team) { create(:team) }
  let(:subject) { described_class.new(team).serializable_hash }

  it { expect(subject[:color]).to eq(team.color) }
  it { expect(subject[:id]).to eq(team.id) }
  it { expect(subject[:name]).to eq(team.name) }
end
