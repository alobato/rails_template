require 'spec_helper'

describe 'passwords/edit.html.erb' do

  before do
    template.stub(:logged_in?).and_return(true)
    template.stub(:current_user).and_return(mock_model(User, :email => 'email@email.com'))
    assigns[:user] = mock_model(User).as_new_record.as_null_object
    render :layout => 'application'
  end

  subject { response.body }

  it { should have_title_with('Alterar senha') }
  it { should have_h1_with('Alterar senha') }

  it 'should render form to change password' do
    subject.should have_selector('form', :method => 'post', :action => change_password_path) do |f|
      f.should have_password_field_for('user[old_password]')
      f.should have_password_field_for('user[password]')
      f.should have_password_field_for('user[password_confirmation]')
      f.should have_submit_button
    end
  end

end
