module FilmHelper


  def icons
    {
      watched:  'icon-eye-open', 
      loved:    'icon-heart', 
      owned:    'icon-home', 
      queued:   'icon-pushpin',
      list:     'icon-list'
    }
  end

  def film_link(film)
    link_to film.title, film, alt: film.title
  end

  def title_with_year(film)
    "#{film.title} " << year(film)
  end

  def directed_by(film)
    "Directed by: #{film.director}" if film.director
  end

  def starring(film)
   "Starring: #{film.starring.join(', ')}" if film.casts
  end

  def film_action_counter(film, action)
    action_css = actioned?(film, action) ? 'actioned' : 'unactioned'
    css = "#{icons[action]} #{action_css}"
    content_tag :i, nil,:class => css, data: {action: action, id: film.id}
  end

  def actioned?(film, action)
    return false unless current_user
    current_user.film_actioned? film, action
  end

  def year(film)
    return "" unless film.year
    "(#{film.year})"
  end

  def tagline(film_view)
    film_view.tagline ? film_view.tagline :  "Overview"
  end

  def action_button(action, film)
    url = update_user_film_path(current_user, action, film.id)
    actioned = actioned?(film, action)
    method =  actioned ? :delete : :put

    content_tag :div, name: action, :class=> 'film-action', data: {href: url, method: method, remote: true } do 
      icon_for(action, actioned)
    end  

    # button_tag type: :button, name: action, :class=> 'film-action', data: {href: url, method: method, remote: true } do 
    #   icon_for(action, actioned)
    # end    
  end

  def action_icon(action, film)
 
    return content_tag(:i,nil,  :class => icons[action]) unless current_user

    url = update_user_film_path(current_user, action, film.id)
   
    actioned = actioned? film, action
    method =  actioned ? :delete : :put
    action_css = actioned ? 'actioned' : 'unactioned' 
    css = "#{icons[action]} #{action_css}"  
    content_tag :i, nil, :class => css, data: {href: url, method: method, action: action, remote: true, id: film.id } 
  end

  def icon_for(action, is_actioned=false)
    action_css = is_actioned ? 'actioned' : 'unactioned'
    css = "#{icons[action]} #{action_css}"
    content_tag :i, nil,:class => css, data: {action: action, }
  end


  def poster_small(film)
    poster_link film, 'w90'
  end

  def poster(film, size='w185')
    size = size ? size : 'w185'
    src = film.has_poster? ? film.poster(size) : "http://placehold.it/#{size.slice(1..-1)}&text=#{film.title}"
    image_tag src, :title=>film.title, alt: "poster for #{film.title}", size: '185x278'
  end

  def poster_link(film, size='w154')
    link_to film_path(film), title: film.title do
      poster film, size
    end
  end
  
  def backdrop_small(film)
    return unless film.has_backdrop?
    backdrop film, film.backdrops[0], 'w154'
  end

  def backdrop(film, backdrop, size = 'w1280')
    return unless backdrop
    image_tag AppConfig.image_uri_for([size, backdrop['file_path']]), title: film.title, alt: "backdrop for #{film.title}"
  end

  def backdrop_link(film, backdrop, size = 'w1280')
    link_to film_path(film), title: film.title do
      backdrop film, backdrop, size
    end
  end

  def trailer_url(film)
    return unless film.has_trailer?
    "http://www.youtube.com/embed/#{film.trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
  end

  def trailer(film)
    return unless film.has_trailer?
    content_tag :iframe, nil, src: trailer_url(film), frameborder: 0, allowfullscreen: true
  end

  def genre_link(genre)
    link_to genre_path(genre['name']) do
      content_tag :span, genre['name'], {:class => 'genre link'}
    end
  end

  def person_link(person)
    link_to person_path(person.id) do
      content_tag :span, person.name, {:class => 'person link'}
    end
  end

  def overview(film, truncate_at=180)
     truncate film.overview, separator: ' ', length: truncate_at, :omission => '...'
  end

  def show_details(title, detail)
    return unless !detail.blank?
    detail = detail.kind_of?(Array) ? detail.join('<br/>').html_safe : detail
    content_tag(:h4, title) + content_tag(:p, detail)
  end


end
