require 'spec_helper'

# Feature: Recover password

#   In order to login
#   As a user
#   I want to recover password

#   Scenario: Recover password with valid email
#     Given I have an account
#     And I am on the recovery page
#     When I fill in "Email" with ...
#     And I press "Recuperar"
#     Then I should see "Sua conta foi criada com sucesso"

describe 'Recover password' do
  
  subject { response.body }
  
  context 'when user is on recovery page' do
  
    before do
      create_user
      visit recover_password_path
    end
  
    it 'should display successful message when enter valid email' do
      fill_in :email, :with => 'email@email.com'
      click_button 'Enviar instruções'
      should have(successful_recover_password_message)
    end
  
    it 'should display error message when enter invalid email' do
      fill_in :email, :with => 'email2@email.com'
      click_button 'Enviar instruções'
      should have(email_not_found_message)
      should have_post_form_to(recover_password_path)
    end

  end
  
  context 'when user access reset password url' do

    it 'should send new password when access valid reset url' do
      perishable_token = create_user.perishable_token
      visit reset_password_path(perishable_token)
      should have(successful_generated_and_sent_password_message)
    end
    
    it 'should send new password when access invalid reset url' do
      create_user
      visit reset_password_path('123')
      should have(reset_password_code_not_found_message)
    end
  
  end
  
end
