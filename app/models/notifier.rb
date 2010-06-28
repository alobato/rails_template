class Notifier < ActionMailer::Base

  def activation_instructions(user)
    setup_email(user)
    subject "Valide seu email"
    body    :complete_activation_url => "http://www.domain.com/v/#{user.activation_code}"
  end

  def activation_confirmation(user)
    setup_email(user)
    subject "Sua conta foi validada!"
  end

  def password_reset_instructions(user)
    setup_email(user)
    subject "Instruções para gerar nova senha"
    body    :complete_reset_password_url => "http://www.domain.com/s/#{user.perishable_token}"
  end

  def new_password(user)
    setup_email(user)
    subject "Sua nova senha"
    body    :new_password => user.password
  end

  private

  def setup_email(user)
    sent_on     Time.now
    recipients  user.email
    from        'Email <noreply@domain.com>'
    from        'Email <noreply@domain.com>' unless ENV['RAILS_ENV'] == 'production'
    body        :first_name => user.first_name
  end

end
