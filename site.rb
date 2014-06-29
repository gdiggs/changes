class Site
  include DataMapper::Resource

  # set up the schema for the item
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :title, String, lazy: false
  property :url, String, lazy: false, unique: true
  property :content, Text, lazy: false

  validates_presence_of :url, :title

  after :create, :get_new_content

  def get_new_content
    response = HTTParty.get(url)
    if response.code == 200
      new_content = response.body
      if new_content != self.content
        # send email of changed content with diff
        self.content = new_content
        self.save!
      end
    else
      # send email of error getting url
    end
  end

end
