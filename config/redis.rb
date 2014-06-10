REDIS_CONFIG = {
  "development" => { namespace: 'Bharkhar', size: 5, url: 'redis://localhost:6379' },
  "test"        => { namespace: 'Bharkhar', size: 5, url: 'redis://localhost:6379' },
  "production"  => {
    namespace: 'Bharkhar',
    size:      5,
    url:       "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}"
  }
}.fetch(Bharkhar.env)
