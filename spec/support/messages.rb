def already_logged_in_message
  'Você já está logado como email@email.com'
end

def save_error_message(errors_quantity)
  return "#{errors_quantity} erro impediu que fosse salvo" if errors_quantity == 1
  "#{errors_quantity} erros impediram que fosse salvo"
end

# Sign up
def successful_signup_message
'Sua conta foi criada com sucesso! Acesse seu email e leia as instruções enviadas para validar sua conta.<br />Se você não receber uma mensagem em sua caixa de entrada dentro de 5 minutos, verifique a pasta de "Spam" ou "Lixo Eletrônico".'
end

def successful_active_message
  'Sua conta foi validada com sucesso! Por favor, faça login para continuar.'
end

def blank_activation_code_message
  'O código de validação está em branco.'
end

def activation_code_not_found_message
  'Não encontramos este código de validação. Você já deve ter validado.'
end

# Login
def invalid_login_message
  'Email e/ou senha não conferem'
end

# Recover password
def successful_recover_password_message
  'As instruções para gerar uma nova senha foram enviadas para email@email.com'
end

def email_not_found_message
  'Email não encontrado.<br />Forneça o email que utilizou ao criar sua conta.'
end

def successful_generated_and_sent_password_message
  'Uma nova senha foi gerada e enviada para email@email.com'
end

def reset_password_code_not_found_message
  'Código não encontrado. A nova senha não foi gerada.'
end

# Change password
def successful_change_password_message
  'A senha foi alterada com sucesso!'
end

def invalid_current_password_message
  'Senha atual inválida'
end

# Edit account
def successful_edit_account_message
  'Sua conta foi alterada com sucesso!'
end