# http://m.onkey.org/2008/12/4/rails-templates
# http://howtocode.com.br/downloads/rails-application-templates.pdf
# http://github.com/scullygroup/scully-rails-template

def file(file_path, origin=open("http://github.com/alobato/rails_template/raw/master/#{file_path}").read)
  super file_path, origin
end

run "rm README public/index.html public/javascripts/* doc/README_FOR_APP"

##### .gitignore #####
file ".gitignore", open("http://github.com/alobato/rails_template/raw/master/gitignore").read

##### gems #####
gem "will_paginate"
gem "settingslogic"
gem "attribute_normalizer"
gem "vestal_versions"
gem "resource_controller"
gem "flash_messages_helper"
gem "warden"
gem "devise"
append_file "config/environments/test.rb", "\nconfig.gem 'rspec', :lib => false"
append_file "config/environments/test.rb", "\nconfig.gem 'rspec-rails', :lib => false"
append_file "config/environments/test.rb", "\nconfig.gem 'webrat'"
append_file "config/environments/test.rb", "\nconfig.gem 'remarkable_rails', :lib => false"
append_file "config/environments/test.rb", "\nconfig.gem 'factory_girl'"
append_file "config/environments/development.rb", "\nconfig.gem 'rails-footnotes'"
append_file "config/environments/development.rb", "\nconfig.action_mailer.default_url_options = { :host => 'localhost:3000' }"

##### settingslogic #####
file "config/application.yml"
file "app/models/settings.rb"

##### app/helpers #####
file "app/helpers/application_helper.rb"

##### app/models #####
file "app/models/admin.rb"
file "app/models/user.rb"
#>>> settingslogic app/models/settings.rb

##### app/views #####
file "app/views/home/index.html.erb"
file "app/views/layouts/application.html.erb"
file "app/views/shared/_codes.html.erb"
file "app/views/shared/_footer.html.erb"
file "app/views/shared/_header.html.erb"

##### config #####
file "config/locales/pt-BR.yml"
gsub_file "config/environment.rb", "  # config.i18n.default_locale = :de", "  config.i18n.default_locale = 'pt-BR'"
#>>> settingslogic config/application.yml
#>>> routes config/routes.rb
#>>> database.yml config/database.yml

##### db/migrate #####
file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_users.rb", open("http://github.com/alobato/rails_template/raw/master/db/migrate/create_users.rb").read
file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_admins.rb", open("http://github.com/alobato/rails_template/raw/master/db/migrate/create_admins.rb").read

##### lib #####
#>>> email lib/smtp_tls.rb

##### public/javascripts #####
file "public/javascripts/jquery-1.4.2.min.js", open("http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js").read
file "public/javascripts/application.js"

##### public/stylesheets #####
file "public/stylesheets/reset.css"
file "public/stylesheets/960.css"
file "public/stylesheets/application.css"

##### spec #####
file "spec/controllers/passwords_controller_spec.rb"
file "spec/controllers/users_controller_spec.rb"
file "spec/controllers/activations_controller_spec.rb"
file "spec/factories/users.rb"
file "spec/integration/change_password_spec.rb"
file "spec/integration/edit_account_spec.rb"
file "spec/integration/login_spec.rb"
file "spec/integration/recover_password_spec.rb"
file "spec/integration/signup_spec.rb"
file "spec/models/user_spec.rb"
file "spec/support/helpers.rb"
file "spec/support/matchers.rb"
file "spec/support/messages.rb"
file "spec/views/passwords/edit.html.erb_spec.rb"
file "spec/views/passwords/new.html.erb_spec.rb"
file "spec/views/users/new.html.erb_spec.rb"

##### database.yml #####
file "config/database.yml", <<-END
development:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: #{@root.split('/').last}_development
  pool: 5
  username: root
  password:
  socket: /tmp/mysql.sock

test:
  adapter: mysql
  encoding: utf8
  reconnect: false
  database: #{@root.split('/').last}_test
  pool: 5
  username: root
  password:
  socket: /tmp/mysql.sock

production:
  adapter: mysql
  encoding: utf8
  database: #{@root.split('/').last}_production
  username: root
  password:
  host: 127.0.0.1
END

##### routes #####
route "map.root :controller => 'home'"
route "map.devise_for :users"
route "map.devise_for :admin"
# route <<-END
# 
#   map.namespace :admin do |admin|
#     admin.resources :home
#     admin.resources :users, :as => 'usuarios', :path_names => { :new => 'novo', :edit => 'editar' }
#   end
# END

##### rspec #####
run "rm -rf test"
generate :rspec
run "mkdir -p spec/integration spec/views spec/models spec/controllers spec/factories"
file "spec/support/matchers.rb"
gsub_file "spec/spec_helper.rb", "#require 'webrat/integrations/rspec-rails'", "require 'webrat/integrations/rspec-rails'"
gsub_file "spec/spec_helper.rb", "require 'spec/rails'", <<-END
require 'spec/rails'

require 'webrat'
require 'remarkable_rails'
require 'factory_girl'

Webrat.configure do |config|
  config.mode = :rails
end
END

##### email #####
email = ask("What's your email?")
password = ask("What's your password?")

file "lib/smtp_tls.rb"
append_file "config/environments/development.rb", <<-END


require 'smtp_tls'
config.action_mailer.smtp_settings = {
  :enable_starttls_auto => true, 
  :address        => "smtp.gmail.com",
  :port           => 587,
  :domain         => "#{email.split('@')[1]}",
  :authentication => :plain,
  :user_name      => "#{email}",
  :password       => "#{password}"
}
END
append_file "config/environments/production.rb", <<-END


ActionMailer::Base.smtp_settings = {
  :address => 'localhost',
  :port => 25,
  :domain => 'domain.com'
}
END

##### app/controllers #####
file "app/controllers/application_controller.rb"
file "app/controllers/home_controller.rb"

##### devise #####
generate :devise_install
generate :devise_views

# TODO: Admin

rake "db:create:all"
rake "db:migrate"
rake "db:test:prepare"
