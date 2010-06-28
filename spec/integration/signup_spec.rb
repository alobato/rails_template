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

  it 'should redirect when signup with valid email and password' do
    signup_user
    should_not have_post_form_to(signup_path)
  end

  it 'should display error message when signup with invalid email and password' do
    signup_user('email.com', '123')
    should have(save_error_message(2))
    should have_post_form_to(signup_path)
  end

  it 'should not display signup form when user already logged in' do
    create_user
    login_user
    visit signup_path
    should_not have_post_form_to(signup_path)
  end

end
