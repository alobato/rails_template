# http://wiki.github.com/dchelimsky/rspec/custom-matchers
# http://rspec.rubyforge.org/rspec/1.2.2/classes/Spec/Matchers.html
# pg 252

# http://github.com/joshknowles/rspec-on-rails-matchers/blob/master/lib/spec/rails/matchers/views.rb

Spec::Matchers.define :have_link_to do |href|
  match do |response|
    extend Webrat::Matchers
    have_selector('a', :href => href).matches? response
  end
end

Spec::Matchers.define :have_post_form_to do |action| 
  match do |response|
    extend Webrat::Matchers
    have_selector('form', :method => 'post', :action => action).matches? response
  end
end

Spec::Matchers.define :have_text_field_for do |attribute| 
  match do |response|
    extend Webrat::Matchers
    have_selector('input', :type => 'text', :name => attribute).matches? response
  end
end

# Spec::Matchers.define :have_text_field_for do |attribute, maxlength| 
#   match do |response|
#     extend Webrat::Matchers
#     have_selector('input', :type => 'text', :name => attribute, :maxlength => maxlength.to_s).matches? response
#   end
# end

Spec::Matchers.define :have_select_field_for do |attribute| 
  match do |response|
    extend Webrat::Matchers
    have_selector('select', :name => attribute).matches? response
  end
end

Spec::Matchers.define :have_textarea_for do |attribute| 
  match do |response|
    extend Webrat::Matchers
    have_selector('textarea', :name => attribute).matches? response
  end
end

Spec::Matchers.define :have_password_field_for do |attribute, maxlength| 
  match do |response|
    extend Webrat::Matchers
    have_selector('input', :type => 'password', :name => attribute, :maxlength => maxlength.to_s).matches? response
  end
end

Spec::Matchers.define :have_check_box_for do |attribute| 
  match do |response|
    extend Webrat::Matchers
    have_selector('input', :type => 'checkbox', :name => attribute).matches? response
  end
end

Spec::Matchers.define :have_submit_button do
  match do |response|
    extend Webrat::Matchers
    have_selector('input', :type => 'submit').matches? response
  end
end

Spec::Matchers.define :have_h1_with do |text| 
  match do |response|
    extend Webrat::Matchers
    have_selector('h1', :content => text).matches? response
  end
end

Spec::Matchers.define :have_title_with do |text|
  match do |response|
    extend Webrat::Matchers
    have_selector('title', :content => text).matches? response
  end
end

Spec::Matchers.define :have_form do
  match do |response|
    extend Webrat::Matchers
    have_selector('form').matches? response
  end
end

Spec::Matchers.define :have_jquery do
  match do |response|
    extend Webrat::Matchers
    response.include?('jquery-1.4.2.min.js') == true
  end
end

Spec::Matchers.define :have_application_script do
  match do |response|
    extend Webrat::Matchers
    response.include?('application.js') == true
  end
end

Spec::Matchers.define :have_jquery_plugin do |text|
  match do |response|
    extend Webrat::Matchers
    response.include?(text) == true
  end
end

Spec::Matchers.define :have_content do |text|
  match do |response|
    extend Webrat::Matchers
    contain(text).matches? response
  end
end

Spec::Matchers.define :have do |text|
  match do |response|
    extend Webrat::Matchers
    contain(text.gsub('<br />', '')).matches? response
  end
end