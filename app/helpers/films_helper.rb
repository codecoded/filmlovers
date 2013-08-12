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

  def sort_option(action, sort_by=:popularity, text)
    path = category_films_url(action: action, sort_by: sort_by, decade: params[:decade], genres: params[:genres])
    content_tag :option, text, value: full_path(), selected: current_url == path || @sort_order == sort_by
  end

  def filter(name, text, value=text)
    link_to text, full_path({name=>value}), class: 'button small filter', data: {'filter-name' => name, 'filter-value' => value.to_param}
  end

  def full_path(filter={})
    filters = {
      action: params[:action],
      sort_by: params[:sort_by],
      decade: filter[:decade] || params[:decade],
      genres: filter[:genres] || params[:genres],
      year: filter[:year] || params[:year]
    }
    category_films_path(filters)
  end
end
