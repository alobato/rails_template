class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :activate]
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      Notifier.deliver_activation_instructions(@user)
      flash[:notice] = 'Sua conta foi criada com sucesso! Acesse seu email e leia as instruções enviadas para validar sua conta.<br />Se você não receber uma mensagem em sua caixa de entrada dentro de 5 minutos, verifique a pasta de "Spam" ou "Lixo Eletrônico".'
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Sua conta foi alterada com sucesso!'
      redirect_to root_path
    else
      render :edit
    end
  end

end
