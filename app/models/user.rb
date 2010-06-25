class User < ActiveRecord::Base
  acts_as_authentic
  
  attr_accessible :terms_of_service, :password, :password_confirmation
  
  validates_acceptance_of :terms_of_service

end