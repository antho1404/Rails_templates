simple_form =   yes? "Use simple form?"
devise =        yes? "Use devise?"
cancan =        yes? "Use cancan?"
active_admin =  yes? "Use active admin?"
bootstrap =     yes? "Use twitter bootstrap?"
compass =       yes? "Use compass?"

# ### Add necessary gems ###
say "Add gems =========="
gem "haml-rails"
gem "thin"
gem "simple_form" if simple_form
gem "devise"      if devise
gem "cancan"      if cancan
gem "activeadmin" if active_admin
if bootstrap
  gem "therubyracer"
  gem "less-rails"
  gem 'twitter-bootstrap-rails', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
end
if compass
  gem 'compass'
  gem_group :assets do
    gem 'compass-rails'
  end
end
gem_group :development do
  gem "quiet_assets"
  gem 'bullet'
end

run "bundle install"

### remove useless files ###
say "Remove useless files =========="
remove_file "public/index.html"
remove_file "app/assets/images/rails.png"

### configure database ####
say "Configure database =========="
user_name = ask "What is your DB id"
password =  ask "What is your DB password"

gsub_file "config/database.yml", /(username\:(.*))/, "username: #{user_name}"
gsub_file "config/database.yml", /(password\:(.*))/, "password: #{password}"
rake "db:setup"

### install gems ###
say "Installing gems =========="

if simple_form
  cmd = ["simple_form:install"]
  cmd << "--bootstrap" if bootstrap
  generate cmd.join(" ")
end
if bootstrap
  generate "bootstrap:install"
  generate "bootstrap:layout application fixed"
end
generate "devise:install"       if devise
generate "active_admin:install" if active_admin
generate "cancan:ability"       if cancan

rake "db:migrate"

### configure git ###
say "Configuring GIT =========="
run "echo 'config/database.yml' >> .gitignore"
git :init
git add: "."
git commit: "-a -m 'Initial commit'"

