class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :activate]
  before_filter :require_user, :only => [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.email = params[:user][:email]
    
    if @user.save
      flash[:notice] = 'Sua conta foi criada com sucesso! Acesse seu email e leia as instruções enviadas para validar sua conta.<br />Se você não receber uma mensagem em sua caixa de entrada dentro de 5 minutos, verifique a pasta de "Spam" ou "Lixo Eletrônico".'
      redirect_to welcome_path
    else
      @user.password = @user.password_confirmation = nil
      render :new
    end
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Sua conta foi alterada com sucesso!"
      redirect_to '/'
    else
      render :edit
    end
  end
  
  def activate
    if params[:activation_code].blank?
      flash[:error] = "O código de validação está em branco."
      redirect_to(login_path) and return
    end
    
    if user = User.find_by_activation_code(params[:activation_code])
      user.activate!
      flash[:notice] = "Sua conta foi validada com sucesso! Por favor, faça login para continuar."
    else
      flash[:error]  = "Não encontramos este código de validação. Você já deve ter validado."
    end

    redirect_to login_path
  end

end