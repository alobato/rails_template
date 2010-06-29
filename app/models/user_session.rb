class UserSession < Authlogic::Session::Base
  def self.disable_magic_states
    true
  end
end
