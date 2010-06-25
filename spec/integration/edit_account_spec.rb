require 'spec_helper'

# Feature: Edit account

#   In order to edit my personal info
#   As a user
#   I want to edit my account

#   Scenario: Edit account
#     Given I am seller
#     And I am on the edit account page
#     When I fill in fields
#     And I press "Salvar"
#     Then I should see "Sua conta foi salva com sucesso"

describe 'Edit account' do
  
  subject { response.body }

  it 'should display successful message when edit with valid values' do
    create_user
    login_user
    visit account_path
    fill_in :user_name, :with => 'Joao'
    click_button 'Salvar'
    should have(successful_edit_account_message)
  end

  it 'should display error message when edit with invalid email and password' do
    create_user
    login_user
    visit account_path
    fill_in :user_name, :with => 'J'
    click_button 'Salvar'
    should have(save_error_message(1))
  end

end
