module FilmHelper

  def directed_by(film_view)
    "Directed by: #{film_view.director}" if film_view.director
  end

  def starring(film)
   "Starring: #{film.credits.cast.take(3).map(&:name).join(', ')}" if film.credits.cast
  end

  def runtime(film)
    film.runtime > 0 ? "#{film.runtime} Mins" : "-- Mins"
  end

  def film_poster_link(film, poster_size='w154')
    link_to film_path(film.id), title: film.title do 
      poster(film, poster_size)
    end
  end

  def year(film_view)
    return "" unless film_view.year
    "(#{film_view.year})"
  end

  def title_with_year(film_view)
    "#{film_view.title} " << year(film_view)
  end

  def tagline(film_view)
    film_view.tagline ? film_view.tagline :  "Overview"
  end

  def action_button(action, presenter)
    url = update_user_film_path(current_user, action, presenter.id)
    actioned = presenter.actioned?(action)
    method =  actioned ? :delete : :put
    button_tag type: :button, name: action, :class=> 'film-action', data: {href: url, method: method, remote: true } do 
      icon_for(action,actioned)
    end    
  end

  def action_icon(action, presenter)
    icons = {
        watched: 'icon-eye-open', 
        loved: 'icon-heart', 
        owned: 'icon-home', 
        queued: 'icon-pushpin'}

   
    return content_tag(:i,nil,  :class => icons[action]) unless current_user

    url = update_user_film_path(current_user, action, presenter.id)
   
    actioned = presenter.actioned?(action)
    method =  actioned ? :delete : :put
    action_css = actioned ? 'actioned' : 'unactioned' 
    css = "#{icons[action]} #{action_css}"  
    content_tag :i, nil, :class => css, data: {href: url, method: method, action: action, remote: true, id: presenter.id } 
  end

  def icon_for(action, is_actioned=false)
    icons = {
      watched: 'icon-eye-open', 
      loved: 'icon-heart', 
      owned: 'icon-home', 
      queued: 'icon-pushpin'}

    action_css = is_actioned ? 'actioned' : 'unactioned'
    css = "#{icons[action]} #{action_css}"
    content_tag :i, nil,:class => css
  end

  def poster(film, size='w154')
    size = size ? size : 'w154'
    src = film.has_poster? ? film.poster(size) : "http://placehold.it/#{size.slice(1..-1)}&text=#{film.title}"
    image_tag src, :title=>film.title, :class=>'small'
  end

  def backdrop_image(backdrop)
     image_tag AppConfig.image_uri_for(['w1280', backdrop['file_path']])
  end

  def backdrop(film, size)
     image_tag film.backdrop size
  end

  def trailer(film)
    return unless film.has_trailer?
    src = "http://www.youtube.com/embed/#{film.trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
    content_tag :iframe, nil, src: src, frameborder: 0, allowfullscreen: true
  end

  def genre_link(genre)
    link_to films_genre_path(genre['name']) do
      content_tag :span, genre['name'], {:class => 'genre link'}
    end
  end

  def overview(film, truncate_at=180)
     truncate film.overview, separator: ' ', length: truncate_at, :omission => '...'
  end

end
