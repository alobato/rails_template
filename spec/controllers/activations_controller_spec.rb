require 'spec_helper'

describe ActivationsController, 'GET new' do
end

describe ActivationsController, 'POST create' do
end

describe ActivationsController, 'GET activate' do
  
  let(:user) { mock_model(User, :activate! => nil) }
  before { User.stub(:find_by_activation_code).with('1234567890').and_return(user) }
  
  it 'finds by activation code' do
    User.should_receive(:find_by_activation_code).with('1234567890').and_return(user)
    get_activate_user
  end
  
  it 'activates the user' do
    user.should_receive(:activate!)
    get_activate_user
  end
  
  it 'sets a flash[:notice]' do
    get_activate_user
    flash[:notice].should == successful_active_message
  end
  
  it 'redirects to login page' do
    get_activate_user
    response.should redirect_to(login_path)
  end
  
  context "when activation code is invalid" do
    it 'sets a flash[:error] for blank activation code' do
      User.stub(:find_by_activation_code).with('').and_return(nil)
      get_activate_user(:activation_code => '')
      flash[:error].should == blank_activation_code_message
    end
    
    it 'sets a flash[:error] for not found activation code' do
      User.stub(:find_by_activation_code).with('123').and_return(nil)
      get_activate_user(:activation_code => '123')
      flash[:error].should == activation_code_not_found_message
    end
  end
  
end

describe ActivationsController do
  it { activate_path(123).should be_eql('/v/123') }
  it { params_from(:get, activate_path(123)).should == {:controller => 'users', :action => 'activate', :activation_code => '123'} }
end

def get_activate_user(options = {})
  get :activate, { :activation_code => '1234567890' }.merge(options)
end
