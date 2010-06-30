require 'spec_helper'

# Feature: Login

#   In order to access the site
#   As a user
#   I want to login

#   Scenario: Login with valid email and password
#     Given I don't have an account
#     And I am on the signup page
#     When I fill in "Email" with ...
#     And I fill in "Password"" with ...
#     And I press "Login"
#     Then I should be redirected to main page or origin page

describe 'Login' do

  before{ create_user }
  subject { response.body }

  it 'should redirect to main page when login with valid email and password' do
    login_user('email@email.com', '123456')
    should have('email@email.com')
    should_not have(invalid_login_message)
    should_not have_post_form_to(login_path)
  end

  it 'should display error message when login with invalid email and password' do
    login_user('email2@email.com', '123456')
    should have(save_error_message(1))
    should have_post_form_to(login_path)
  end

  it 'should not display logged email when logout' do
    login_user('email@email.com', '123456')
    visit logout_path
    should_not have('email@email.com')
  end

end
