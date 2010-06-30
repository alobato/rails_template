require 'spec_helper'

describe PasswordsController, 'POST create' do

  context 'when found user by email' do
    let(:user) { mock_model(User, :save => nil, :password_reset_code= => nil, :email => 'email@email.com', :first_name => 'Pedro', :perishable_token => '123', :reset_perishable_token => nil, :password_reset_code => '123', :name => 'Joao') }
    before { User.stub(:find_by_email).with('email@email.com').and_return(user) }

    it 'find by email' do
      User.should_receive(:find_by_email).with('email@email.com')
      post_create_password
    end
    
    it 'deliver email' do
      mailer = Notifier.create_password_reset_instructions(user)
      lambda { Notifier.create_password_reset_instructions(user) }.should_not raise_error
      lambda { Notifier.deliver(mailer) }.should_not raise_error
      lambda { Notifier.deliver(mailer) }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end
    
    it 'sets flash[:notice]' do
      post_create_password
      flash[:notice].should == successful_recover_password_message
    end
    
    it 'redirects to login_path' do
      post_create_password
      response.should redirect_to(login_path)
    end
  end

  context 'when not found user by email' do
    before do
      User.stub(:find_by_email).with('email2@email.com').and_return(nil)
      @controller.instance_eval{flash.stub!(:sweep)}
      post_create_password :email => 'email2@email.com'
    end
    
    it 'sets flash.now[:error]' do
      flash.now[:error].should == email_not_found_message
    end

    it 'renders new template' do
      response.should render_template(:new)
    end
  end

end

describe PasswordsController, 'GET reset' do

  context 'when found user by password_reset_code' do
    let(:user) { mock_model(User, :email => 'email@email.com', :name => nil, :first_name => 'Pedro', :password= => nil, :password => nil, :password_confirmation= => nil, :perishable_token= => nil, :save => nil, :save_without_session_maintenance => nil) }
    before { User.stub(:find_using_perishable_token).with('1234567890').and_return(user) }

    it 'find by password_reset_code' do
      User.should_receive(:find_using_perishable_token).with('1234567890').and_return(user)
      get_reset_password
    end
  
    it 'sets password to user' do
      user.should_receive(:password=)
      get_reset_password
    end
  
    it 'save user' do
      user.should_receive(:save_without_session_maintenance).with(false)
      get_reset_password
    end
    
    it 'deliver email' do
      mailer = Notifier.create_new_password(user)
      lambda { Notifier.create_new_password(user) }.should_not raise_error
      lambda { Notifier.deliver(mailer) }.should_not raise_error
      lambda { Notifier.deliver(mailer) }.should change(ActionMailer::Base.deliveries,:size).by(1)
    end
    
    it 'sets flash[:notice]' do
      get_reset_password
      flash[:notice].should == successful_generated_and_sent_password_message
    end
    
    it 'redirects to login_path' do
      get_reset_password
      response.should redirect_to(login_path)
    end
  end
  
  context 'when not found user by password_reset_code' do
    before do
      User.stub(:find_using_perishable_token).with('123').and_return(nil)
      @controller.instance_eval{flash.stub!(:sweep)}
      get_reset_password :password_reset_code => '123'
    end
    
    it 'sets flash.now[:error]' do
      flash.now[:error].should == reset_password_code_not_found_message
    end

    it 'renders new template' do
      response.should render_template(:new)
    end
  end
  
end

describe PasswordsController, 'PUT update' do

  context 'when current password is ok' do
    let(:user) { mock_model(User, :valid_password? => true, :password= => nil, :password_confirmation= => nil) }
    before do
      @controller.stub(:current_user).and_return(user)
    end
  
    it 'sets flash[:notice] and redirects to home' do
      user.stub(:save).and_return(true)
      put_update_password
      flash[:notice].should == successful_change_password_message
      response.should redirect_to(root_path)
    end
  end

end

describe PasswordsController do
  it { recover_password_path.should be_eql('/recuperar-senha') }
  it { reset_password_path(123).should be_eql('/s/123') }
  it { params_from(:get, recover_password_path).should == {:controller => 'passwords', :action => 'new'} }
  it { params_from(:post, recover_password_path).should == {:controller => 'passwords', :action => 'create'} }
  it { params_from(:get, reset_password_path(123)).should == {:controller => 'passwords', :action => 'reset', :password_reset_code => '123'} }
end

def post_create_password(options = {})
  post :create, { :email => 'email@email.com' }.merge(options)
end

def get_reset_password(options = {})
  get :reset, { :password_reset_code => '1234567890' }.merge(options)
end

def put_update_password(options = {})
  put :update, { :user => { :old_password => '123456', :password => '654321', :password_confirmation => '654321' } }.merge(options)
end
