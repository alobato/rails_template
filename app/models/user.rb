class User < ActiveRecord::Base
  acts_as_authentic
  
  before_create :set_new_activation_code

  attr_accessor :old_password

  attr_accessible :terms_of_service, :name
  
  validates_acceptance_of :terms_of_service
  
  def first_name(user)
    user.name.split(' ')[0] unless user.name.blank?
  end

  def active?
    activation_code.nil?
  end

  def activate!
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  
  private
  
  def set_new_activation_code
    self.activation_code = self.class.make_token[0, 10]
  end

end