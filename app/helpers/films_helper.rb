module FilmsHelper

  def page_link(is_required, params, icon_class, id)
    return unless is_required
    link_to current_url(params), remote: true, :id=>id, data:{action: 'link'} do 
      content_tag :i, nil, :class => icon_class
    end
  end

  def user_films_sort_option(user, action, order=:title, by=:asc, text)
    content_tag :option, text, value: user_film_path(user, action, order: order, by: by)
  end

  def films_sort_option(action, sorted_by, text)
    path = category_films_url(action: action, sorted_by: sorted_by)
    content_tag :option, text, value: category_films_path(action: action, sorted_by: sorted_by), selected: current_url == path
  end
end
