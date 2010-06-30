def create_user(options = {})
  Factory(:valid_user, options)
end

def create_and_active_user
  Factory(:valid_user)
  User.find_by_email('email@email.com').update_attribute(:activation_code, nil)
end

def signup_user(email = Factory.build(:valid_user).email, password = Factory.build(:valid_user).password)
  visit logout_path
  visit signup_path
  fill_in :user_email, :with => email
  fill_in :user_password, :with => password
  fill_in :user_password_confirmation, :with => password
  click_button 'Criar conta'
end

def login_user(email = Factory.build(:valid_user).email, password = Factory.build(:valid_user).password)
  visit logout_path
  visit login_path
  fill_in :user_session_email, :with => email
  fill_in :user_session_password, :with => password
  click_button 'Login'
end

def show(body)
  filename = "#{RAILS_ROOT}/tmp/#{Time.now.to_i}.html"
  File.open(filename, "w") do |f|
    f.write body
  end
  require "launchy"
  Launchy::Browser.run(filename)
end
