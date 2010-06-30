require 'spec_helper'

describe User do
  
  should_not_allow_mass_assignment_of :email, :password, :password_confirmation, :activation_code,
    :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token,
    :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at,
    :current_login_ip, :last_login_ip, :activated_at

  should_validate_acceptance_of   :terms_of_service
  should_validate_confirmation_of :password

  should_allow_values_for :email, 'joao@joao.com', ' joao@js.com'
  should_allow_values_for :password, 'as3a$#aA'
  should_allow_values_for :name, 'João', 'Ana', 'Pedro Paulo da Silva Pereira Sergio Alcantara Moreira'

  should_not_allow_values_for :email, '@joao.com', ' j@j', 'as'
  should_not_allow_values_for :password, '123'

  it 'should be valid' do
    Factory.build(:valid_user).should be_valid
  end

  it 'should require presence of email' do
    Factory.build(:valid_user, :email => '').should_not be_valid
  end

  it 'should require presence of password' do
    Factory.build(:valid_user, :password => '').should_not be_valid
  end
  
  it 'should require presence of password confirmation' do
    Factory.build(:valid_user, :password_confirmation => '').should_not be_valid
  end
  
  it 'saves new user sucessfully' do
    lambda { Factory(:valid_user) }.should change(User, :count).by(1)
  end
  
  it 'should not saves new user' do
    lambda { Factory(:invalid_user) }.should raise_error
  end

end
