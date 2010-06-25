class ActivationsController < ApplicationController
  before_filter :require_user, :only => [:new, :create]

  def new
  end

  def create
    user = current_user
    if !user.active?
      Notifier.deliver_activation_instructions(user)
      flash[:notice] = 'Acesse seu email e leia as instruções enviadas para validar sua conta.<br />Se você não receber uma mensagem em sua caixa de entrada dentro de 5 minutos, verifique a pasta de "Spam" ou "Lixo Eletrônico".'
      redirect_to root_path
    else 
      flash[:error]  = "Sua conta já foi validada."
      render :new
    end
  end
  
  def activate
    current_user_session.destroy
    if user = User.find_by_activation_code(params[:activation_code])
      user.activate!
      Notifier.deliver_activation_confirmation(user)
      flash[:notice] = "Sua conta foi validada com sucesso! Por favor, faça login para continuar."
    else
      flash[:error]  = "Não encontramos este código de validação. Você já deve ter validado."
    end
    redirect_to login_path
  end

end
