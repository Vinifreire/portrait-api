REDIS_CONFIG = YAML.safe_load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result, aliases: true)[Rails.env].symbolize_keys
