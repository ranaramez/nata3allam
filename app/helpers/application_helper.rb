module ApplicationHelper

  def nav_link(link_text, link_path, classes)
    class_name = current_page?(link_path) ? 'active ' : ''

    content_tag(:li, class: class_name) do
      link_to link_path, class: classes do
        content_tag(:i, "", nil).concat(link_text)
      end
    end
  end
end
