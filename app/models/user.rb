class User < ActiveRecord::Base
  acts_as_authentic
  
  before_create :set_new_activation_code

  attr_accessor :old_password

  attr_accessible :terms_of_service, :name
  
  validates_acceptance_of :terms_of_service
  
  def first_name
    name.split(' ')[0] unless name.blank?
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
  
  def secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def make_token
    secure_digest(Time.now, (1..10).map{ rand.to_s })
  end

  def set_new_activation_code
    self.activation_code = make_token[0, 10]
  end

end
