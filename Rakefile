task :require_app do
  require './changes'
end

task :update_sites => [:require_app] do
  Site.all.each do |site|
    puts "Checking for updates to '#{site.title}'"
    site.get_new_content
  end
end
