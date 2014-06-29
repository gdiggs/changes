class Site
  include DataMapper::Resource

  # set up the schema for the item
  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :title, String, lazy: false
  property :url, Text, lazy: false, unique: true
  property :content, Text, lazy: false

  validates_presence_of :url, :title

  before :create, :get_new_content

  def get_new_content
    response = HTTParty.get(url)
    if response.code == 200
      new_content = response.body
      if new_content != self.content
        # send email of changed content with diff
        self.send_update_email
        self.content = new_content
        self.save!
      end
    else
      # send email of error getting url
    end
  end

  def send_update_email
    Mailer.deliver(to: 'gordon@diggs.me',
                   from: 'changes@diggs.me',
                   subject: "[Changes] Change to '#{self.title}'",
                   text: "The content of #{self.url} has changed")
  end

end
