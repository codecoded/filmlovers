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
    content_tag :option, text, value: full_path(action, sort_by), selected: current_url == path || @sort_order == sort_by
  end

  def filter_decade(action, sort_by=:popularity, decade)
    link_to decade, full_path(action, sort_by, decade), class: 'button small filter'
  end

  def filter_genre(action, sort_by=:popularity, genre)
    link_to genre.name, full_path(action, sort_by, params[:decade], genre), class: 'button small filter'
  end

  def full_path(action, sort_by, decade=params[:decade], genres=params[:genres])
    category_films_path(action: action, sort_by: sort_by, decade: decade, genres: genres)
  end
end
