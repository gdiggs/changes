class User
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def id
    options['uid']
  end

  def save
    $redis.mapped_hmset("users:#{id}", options)
  end
end
