require 'spec_helper'

# Feature: Change password

#   In order to have security
#   As a user
#   I want to change my password

#   Scenario: Change password
#     Given I am user
#     And I am on the edit password page
#     When I fill in current password with correct value
#     And I fill in new password
#     And I fill in new password confirmation
#     And I press "Alterar"
#     Then I should see "Sua senha foi alterada com sucesso"

describe 'Change password' do
  
  before do
    create_user
    login_user
    visit change_password_path
  end
  
  subject { response.body }
  
  it 'should display successful message when change password with valid values' do
    fill_in :user_old_password, :with => '123456'
    fill_in :user_password, :with => '654321'
    fill_in :user_password_confirmation, :with => '654321'
    click_button 'Alterar'
    should have(successful_change_password_message)
  end
  
  it 'should display error message when change password with invalid password confirmation' do
    fill_in :user_old_password, :with => '123456'
    fill_in :user_password, :with => '654321'
    fill_in :user_password_confirmation, :with => '777777'
    click_button 'Alterar'
    should have(save_error_message(1))
  end
  
  it 'should display error message when change password with invalid current password' do
    fill_in :user_old_password, :with => '111222'
    fill_in :user_password, :with => '654321'
    fill_in :user_password_confirmation, :with => '654321'
    click_button 'Alterar'
    should have(invalid_current_password_message)
  end
  
end