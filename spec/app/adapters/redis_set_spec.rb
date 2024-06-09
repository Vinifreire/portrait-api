describe RedisAdapter, '#get' do
  subject(:redis_client) { described_class.set('key', 'value') }

  it 'calls set' do
    expect_any_instance_of(Redis).to receive(:set)
      .with('key', 'value')

    redis_client
  end
end
