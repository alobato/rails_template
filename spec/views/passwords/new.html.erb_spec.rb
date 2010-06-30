require 'spec_helper'

describe 'passwords/new.html.erb' do

  before do
    template.stub(:logged_in?).and_return(false)
    render :layout => 'application'
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
