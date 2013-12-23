module ApplicationHelper
  def inside_layout(layout, &block)
    layout = "layouts/#{layout}" unless layout =~ %r[\Alayouts/]
    content_for :content, capture(&block)
    render template: layout
  end

  def side_nav_active(controller, actions)
    if controller_name == controller && actions.include?(action_name)
      'nav-item active'
    else
      'nav-item'
    end
  end
end
