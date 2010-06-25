class PasswordsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  # Don't write passwords as plain text to the log files  
  filter_parameter_logging :old_password, :password, :password_confirmation  

  def new
  end

  def create
    if user = User.find_by_email(params[:email])
      reset_perishable_token!
      Notifier.deliver_password_reset_instructions(self)
      flash[:notice] = "As instruções para gerar uma nova senha foram enviadas para #{user.email}"
      redirect_to login_path
    else
      flash.now[:error] =  "Email não encontrado.<br />Forneça o email que utilizou ao criar sua conta."
      render :new
    end
  end

  def reset
    current_user_session.destroy
    if user = User.find_using_perishable_token(params[:password_reset_code])
      user.password = user.password_confirmation = random_password
      user.save(false)
      Notifier.deliver_new_password(user)
      flash[:notice] = "Uma nova senha foi gerada e enviada para #{user.email}"
      redirect_to login_path
    else
      flash.now[:error] = "Código não encontrado. A nova senha não foi gerada."
      render :new
    end
  end

  def edit
    @user = current_user
  end

  # http://stackoverflow.com/questions/2231524/how-do-i-write-and-test-password-changes-when-using-authlogic
  def update
    @user = current_user
    if @user.valid_password?(params[:user][:old_password])
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        flash[:notice] = "A senha foi alterada com sucesso!"
        redirect_to root_path
      else
        render :edit
      end
    else
      flash[:error] = 'Senha atual inválida'
      render :edit
    end
  end

  private

  def random_password(len = 6)
    chars = (("a".."z").to_a + ("1".."9").to_a) - %w(i o 0 1 l 0)
    newpass = Array.new(len, '').collect{chars[rand(chars.size)]}.join
  end  
  
end
