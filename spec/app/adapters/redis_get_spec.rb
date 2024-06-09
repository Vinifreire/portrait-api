describe RedisAdapter, '#set' do
  subject(:redis_client) { described_class.get('key') }

  it 'calls set' do
    expect_any_instance_of(Redis).to receive(:get)
      .with('key')

    redis_client
  end
end
