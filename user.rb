class User
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def self.get(id)
    if opts = $redis.hgetall("users:#{id}")
      User.new(opts)
    end
  end

  def id
    options['uid']
  end

  def save
    $redis.mapped_hmset("users:#{id}", options)
  end

  def method_missing(method_name, *arguments, &block)
    if options.has_key?(method_name.to_s)
      options[method_name.to_s]
    else
      super
    end
  end

  def respond_to?(method_name, include_private = false)
    options.has_key?(method_name.to_s) || super
  end
end
