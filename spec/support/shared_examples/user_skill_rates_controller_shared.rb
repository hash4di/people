shared_examples 'returns correct hash and response is 200' do
  it { expect(response.status).to eq(200) }

  it 'returns correct hash', :aggregate_failures do
    skill_rates = json_response['user_skill_rates']
    expect(skill_rates).to be_a(Array)
    expect(skill_rates).to eq(expected_array)
  end
end

shared_examples 'returns empty hash and response is 200' do
  it { expect(response.status).to eq(200) }

  it 'returns empty hash', :aggregate_failures do
    skill_rates = json_response['user_skill_rates']
    expect(skill_rates).to be_a(Array)
    expect(skill_rates.size).to eq(0)
  end
end
