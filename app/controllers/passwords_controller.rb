class PasswordsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :update

  # Don't write passwords as plain text to the log files  
  filter_parameter_logging :old_password, :password, :password_confirmation  

  def new
  end

  def create
    if user = User.find_by_email(params[:email])
      user.password_reset_code = make_password_reset_code
      user.save(false)
      UserMailer.deliver_reset_password(user)
      flash[:notice] = "As instruções para gerar uma nova senha foram enviadas para #{user.email}"
      redirect_to login_path
    else
      flash.now[:error] =  "Email não encontrado.<br />Forneça o email que utilizou ao criar sua conta."
      render :new
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
      
    if params[:user][:old_password].blank? || !@user.authenticated?(params[:user][:old_password])
      flash.now[:error] = "Senha atual inválida"
      render :edit and return
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    #to require password
    @user.crypted_password = ''

    if @user.save
      flash[:notice] = "A senha foi alterada com sucesso!"
      redirect_to '/'
    else
      @user.password = @user.password_confirmation = nil
      render :edit
    end
  end
  
  def reset
    if user = User.find_by_password_reset_code(params[:password_reset_code])
      user.password = user.password_confirmation = random_password
      user.password_reset_code = nil
      user.save(false)
      UserMailer.deliver_new_password(user)
      flash[:notice] = "Uma nova senha foi gerada e enviada para #{user.email}"
      redirect_to login_path
    else
      flash.now[:error] = "Código não encontrado. A nova senha não foi gerada."
      render :new
    end
  end

  protected
  
  def make_password_reset_code
    Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)[0,10]
  end

  def random_password(len = 6)
    chars = (("a".."z").to_a + ("1".."9").to_a) - %w(i o 0 1 l 0)
    newpass = Array.new(len, '').collect{chars[rand(chars.size)]}.join
  end  
  
end