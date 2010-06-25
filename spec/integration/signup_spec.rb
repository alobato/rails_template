require 'spec_helper'

# Feature: Sign up

#   In order to access the site
#   As a user
#   I want to create an account

#   Scenario: Signup with valid email and password
#     Given I don't have an account
#     And I am on the signup page
#     When I fill in "Email" with ...
#     And I fill in "Password"" with ...
#     And I fill in "Password Confirmation" with ...
#     And I press "Criar conta"
#     Then I should see "Sua conta foi criada com sucesso"

describe 'Sign up' do
  
  subject { response.body }

  it 'should display successful message when signup with valid email and password' do
    signup_user
    should have(successful_signup_message)
    should_not have_post_form_to(signup_path)
  end

  it 'should display error message when signup with invalid email and password' do
    signup_user('email.com', '123')
    should have(save_error_message(2))
    should have_post_form_to(signup_path)
    should_not have(successful_signup_message)
  end

  it 'should display alert message when user already logged in' do
    create_user
    login_user
    visit signup_path
    should have(already_logged_in_message)
  end

end
