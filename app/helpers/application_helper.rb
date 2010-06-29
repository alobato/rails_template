# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(title)
    content_for(:title) { concat("#{title}") }
  end

  def javascript(*sources)
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
