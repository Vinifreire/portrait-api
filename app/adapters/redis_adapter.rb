class RedisAdapter
  class << self
    def url
      @url ||= "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}" \
               "/#{REDIS_CONFIG[:db]}"
    end

    delegate :get, to: :instance
    delegate :set, to: :instance

    def set_with_expire(key, value, expire=REDIS_CONFIG[:expire])
      instance.set(key, value, ex: expire)
    end

    def delete(key)
      instance.del(key)
    end

    private

    def instance
      @instance ||= ::Redis.new(url: url)
    end

    def env
      @env ||= App.env(:redis)
    end
  end
end
