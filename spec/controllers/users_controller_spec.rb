require 'spec_helper'

describe UsersController, 'GET new' do
  
  let(:user) { mock_model(User) }

  it 'creates a new user' do
    User.should_receive(:new).and_return(user)
    get :new
  end

  it 'assigns @user' do
    User.stub(:new).and_return(user)
    get :new
    assigns[:user].should == user
  end

end

describe UsersController, 'POST create' do
  
  let(:user) { mock_model(User, :save => true, :email= => nil, :password= => nil, :password_confirmation= => nil) }
  before { User.stub(:new).and_return(user) }

  it 'creates a new user' do
    User.should_receive(:new).with('email' => 'email@email.com', 'password' => '123456', 'password_confirmation' => '123456').and_return(user)
    post_create_user
  end
  
  it 'receives the email' do
    user.should_receive(:email=).with('email@email.com')
    post_create_user
  end

  it 'saves the user' do
    user.should_receive(:save).and_return(true)
    post_create_user
  end

  it 'sets a flash[:notice]' do
    post_create_user
    flash[:notice].should == successful_signup_message
  end

  it 'redirects to root' do
    post_create_user
    response.should redirect_to(root_path)
  end
  
  context "when the user fails to save" do
    before { user.stub(:save).and_return(false) }

    it 'assigns @user' do
      post_create_user
      assigns[:user].should == user
    end

    it 'renders the new template' do
      post_create_user
      response.should render_template(:new)
    end
  end 

end

describe UsersController do
  it { signup_path.should be_eql('/criar-conta') }
  it { params_from(:get, signup_path).should == {:controller => "users", :action => "new"} }
  it { params_from(:post, signup_path).should == {:controller => "users", :action => "create"} }
end

def post_create_user
  post :create, :user => { 'email' => 'email@email.com', 'password' => '123456', 'password_confirmation' => '123456' }
end
