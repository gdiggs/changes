class Site
  include HTTParty

  attr_accessor :url, :content

  def get_new_content
    response = self.class.get(url)
    if response.code == 200
      self.content = response.body
    else
      # do something because it's bad
    end
  end

end
