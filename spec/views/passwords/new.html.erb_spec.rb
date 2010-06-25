require 'spec_helper'

describe 'passwords/new.html.erb' do

  context 'when user is not logged in' do
    before do
      template.stub(:logged_in?).and_return(false)
      render
    end

    subject { response.body }

    it { should have_title_with('Recuperar senha') }
    it { should have_h1_with('Recuperar senha') }

    it 'should render form to recover password' do
      subject.should have_selector('form', :method => 'post', :action => recover_password_path) do |f|
        f.should have_text_field_for('email')
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

    it { should have_content(already_logged_in_message) }
    it { should_not have_form }
  end

end
