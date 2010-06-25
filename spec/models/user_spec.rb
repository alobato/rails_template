require 'spec_helper'

describe User do
  
  should_not_allow_mass_assignment_of :email, :password, :password_confirmation, :activation_code,
    :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token,
    :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at,
    :current_login_ip, :last_login_ip, :activated_at

  should_validate_acceptance_of   :terms_of_service
  should_validate_presence_of     :email
  should_validate_presence_of     :password
  should_validate_presence_of     :password_confirmation
  should_validate_confirmation_of :password

  should_allow_values_for :email, 'joao@joao.com', ' joao@js.com'
  should_allow_values_for :password, 'as3a$#aA'
  should_allow_values_for :screen_name, 'jo', 'joao123a', 'asdfghjklqwerty', 'Jas231f', 'jas_teste', '_a'
  should_allow_values_for :name, 'João', 'Ana', 'Pedro Paulo da Silva Pereira Sergio Alcantara Moreira'

  should_not_allow_values_for :email, '@joao.com', ' j@j', 'as', 'email1@gmail.com.br', 'email1@hotmail.com.br', 'email1@mailinator.com'
  should_not_allow_values_for :password, '12345'
  should_not_allow_values_for :name, 'a', 'ab'
  
  it 'saves new user sucessfully' do
    lambda { Factory(:valid_user) }.should change(User, :count).by(1)
  end
  
  it 'should not saves new user' do
    lambda { Factory(:invalid_user) }.should raise_error
  end
  
  it 'should not update user with update_attributes' do
    user = Factory(:valid_user)
    user.update_attributes(:email => 'email2@email2.com')
    User.find_by_email('email2@email2.com') == nil
  end

end
