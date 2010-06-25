# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def flash_message
    if flash[:notice]
      content_tag 'p', flash[:notice], :class => 'flash notice'
    elsif flash[:error]
      str = content_tag 'p', flash[:error], :class => 'flash error'
    end
  end

  def title(title)
    content_for(:title) { concat("#{title}") }
  end

  def javascript(*sources)
    # sources.map! {|x| if x == 'jquery-1.4.2.min' then 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js' else x end } if sources.respond_to?(:map)
    content_for(:head) do
      concat(javascript_include_tag(sources))
    end
  end

  def css(*sources)
    content_for(:head) do
      concat(stylesheet_link_tag(sources))
    end
  end

end
