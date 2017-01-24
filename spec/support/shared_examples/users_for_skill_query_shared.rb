shared_examples 'returns correct results' do
  it 'returns correct ordered users', :aggregate_failures do
    expect(results[0].user_skill_rate_id).to eq(
      user_skill_rate_favorite_rate_2.id
    )
    expect(results[1].user_skill_rate_id).to eq(
      user_skill_rate_not_favorite_rate_2.id
    )
    expect(results[2].user_skill_rate_id).to eq(
      user_skill_rate_favorite_rate_1.id
    )
  end

  it 'returns user with required attributes', :aggregate_failures do
    expect(result_object.serializable_hash).to include(
      'user_skill_rate_id' => user_skill_rate_favorite_rate_2.id,
      'rate' => user_skill_rate_favorite_rate_2.rate,
      'favorite' => user_skill_rate_favorite_rate_2.favorite,
      'user_id' => user_skill_rate_favorite_rate_2.user_id,
      'first_name' => user_skill_rate_favorite_rate_2.user.first_name,
      'last_name' => user_skill_rate_favorite_rate_2.user.last_name
    )
  end
end
