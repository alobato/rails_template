# http://m.onkey.org/2008/12/4/rails-templates
# http://howtocode.com.br/downloads/rails-application-templates.pdf
# http://github.com/scullygroup/scully-rails-template

def file(file_path, origin=open("http://github.com/alobato/rails_template/raw/master/#{file_path}").read)
  super file_path, origin
end

run "rm README public/index.html public/javascripts/* doc/README_FOR_APP"

##### .gitignore #####
file ".gitignore", open("http://github.com/alobato/rails_template/raw/master/gitignore").read

##### Gemfile #####
# # http://gembundler.com/rails23.html
file "config/preinitializer.rb"
file "Gemfile"
gsub_file "config/boot.rb", "# All that for this:\nRails.boot!", <<-END

class Rails::Boot
  def run
    load_initializer

    Rails::Initializer.class_eval do
      def load_gems
        @bundler_loaded ||= Bundler.require :default, Rails.env
      end
    end

    Rails::Initializer.run(:set_load_path)
  end
end

# All that for this:
Rails.boot!
END

##### gems #####
# gem "authlogic"
# gem "will_paginate"
# gem "settingslogic"
# append_file "config/environments/test.rb", "\nconfig.gem 'rspec', :lib => false"
# append_file "config/environments/test.rb", "\nconfig.gem 'rspec-rails', :lib => false"
# append_file "config/environments/test.rb", "\nconfig.gem 'webrat'"
# append_file "config/environments/test.rb", "\nconfig.gem 'remarkable_rails', :lib => false"
# append_file "config/environments/test.rb", "\nconfig.gem 'factory_girl'"
# append_file "config/environments/development.rb", "\nconfig.gem 'rails-footnotes'"

##### settingslogic #####
file "config/application.yml"
file "app/models/settings.rb"

##### app/controllers #####
file "app/controllers/activations_controller.rb"
file "app/controllers/application_controller.rb"
file "app/controllers/home_controller.rb"
file "app/controllers/passwords_controller.rb"
file "app/controllers/user_sessions_controller.rb"
file "app/controllers/users_controller.rb"

##### app/helpers #####
file "app/helpers/application_helper.rb"

##### app/models #####
file "app/models/notifier.rb"
file "app/models/user.rb"
file "app/models/user_session.rb"
# settingslogic app/models/settings.rb

##### app/views #####
file "app/views/activations/new.html.erb"
file "app/views/home/index.html.erb"
file "app/views/layouts/application.html.erb"
file "app/views/notifier/activation_confirmation.erb"
file "app/views/notifier/activation_instructions.erb"
file "app/views/notifier/new_password.erb"
file "app/views/notifier/password_reset_instructions.erb"
file "app/views/passwords/edit.html.erb"
file "app/views/passwords/new.html.erb"
file "app/views/shared/_codes.html.erb"
file "app/views/shared/_footer.html.erb"
file "app/views/shared/_header.html.erb"
file "app/views/user_sessions/new.html.erb"
file "app/views/users/new.html.erb"

##### config #####
file "config/locales/pt-BR.yml"
gsub_file "config/environment.rb", "  # config.i18n.default_locale = :de", "  config.i18n.default_locale = 'pt-BR'"

# settingslogic config/application.yml
# routes config/routes.rb
# database.yml config/database.yml

##### db/migrate #####
file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_users.rb", open("http://github.com/alobato/rails_template/raw/master/db/migrate/create_users.rb").read

##### lib #####
# email lib/smtp_tls.rb

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

route "map.resources :users"
route "map.signup '/criar-conta', :controller => 'users', :action => 'new', :conditions => { :method => :get }"
route "map.signup '/criar-conta', :controller => 'users', :action => 'create', :conditions => { :method => :post }"
route "map.my_account '/minha-conta', :controller => 'users', :action => 'edit', :conditions => { :method => :get }"
route "map.my_account '/minha-conta', :controller => 'users', :action => 'update', :conditions => { :method => :put }"
route "map.activate '/v/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil, :conditions => { :method => :get }"

route "map.resources :user_sessions"
route "map.login '/login', :controller => 'user_sessions', :action => 'new', :conditions => { :method => :get }"
route "map.login '/login', :controller => 'user_sessions', :action => 'create', :conditions => { :method => :post }"
route "map.logout '/sair', :controller => 'user_sessions', :action => 'destroy'"

route "map.resources :passwords"
route "map.change_password '/alterar-senha', :controller => 'passwords', :action => 'edit', :conditions => { :method => :get }"
route "map.change_password '/alterar-senha', :controller => 'passwords', :action => 'update', :conditions => { :method => :put }"
route "map.recover_password '/recuperar-senha', :controller => 'passwords', :action => 'new', :conditions => { :method => :get }"
route "map.recover_password '/recuperar-senha', :controller => 'passwords', :action => 'create', :conditions => { :method => :post }"
route "map.reset_password '/s/:password_reset_code', :controller => 'passwords', :action => 'reset', :password_reset_code => nil, :conditions => { :method => :get }"

route <<-END

  map.namespace :admin do |admin|
    admin.resources :home
    admin.resources :users, :as => 'usuarios', :path_names => { :new => 'novo', :edit => 'editar' }
  end
END

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

# TODO: Admin
