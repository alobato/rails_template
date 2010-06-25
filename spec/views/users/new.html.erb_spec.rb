require 'spec_helper'

describe 'users/new.html.erb' do

  context 'when user is not logged in' do
    before do
      assigns[:user] = mock_model(User).as_new_record.as_null_object
      template.stub!(:logged_in?).and_return(false)
      render
    end

    subject { response.body }

    it { should have_title_with('Criar conta') }
    it { should have_h1_with('Crie sua conta') }
    it { should have_link_to('/termos') }

    it 'should render form to create user' do
      subject.should have_selector('form', :method => 'post', :action => signup_path) do |f|
        f.should have_text_field_for('user[email]')
        f.should have_password_field_for('user[password]')
        f.should have_password_field_for('user[password_confirmation]')      
        f.should have_check_box_for('user[terms_of_service]')
        f.should have_submit_button
      end
    end
  end

  context 'when user is logged in' do
    before do
      template.stub(:current_user).and_return(mock_model(User, :email => 'email@email.com'))
      template.stub(:logged_in?).and_return(true)
      render
    end

    subject { response.body }

    it { should have(already_logged_in_message) }
    it { should_not have_form }
  end

end
