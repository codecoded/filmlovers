module FilmsHelper

  def page_link(is_required, params, icon_class, id)
    return unless is_required
    link_to current_url(params), remote: true, :id=>id do 
      content_tag :i, nil, :class => icon_class
    end
  end


end
