describe RedisAdapter, '#set_with_expire' do
  subject(:redis_client) { described_class.set_with_expire('key', 'value', 24) }

  it 'calls set with expire' do
    expect_any_instance_of(Redis).to receive(:set)
      .with('key', 'value', ex: 24)

    redis_client
  end
end
