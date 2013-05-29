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

  def title_with_year(film)
    "#{film.title} " << year(film)
  end

  def directed_by(film_view)
    "Directed by: #{film_view.director}" if film_view.director
  end

  def starring(film)
   "Starring: #{film.credits.cast.take(3).map(&:name).join(', ')}" if film.casts
  end

  def runtime(film)
    film.runtime || 0 > 0 ? "#{film.runtime} Mins" : "-- Mins"
  end

  def film_poster_link(film, poster_size='w154')
    link_to film_path(film), title: film.title do 
      poster(film, poster_size)
    end
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
    button_tag type: :button, name: action, :class=> 'film-action', data: {href: url, method: method, remote: true } do 
      icon_for(action, actioned)
    end    
  end

  def action_icon(action, film)
    # icons = {
    #     watched: 'icon-eye-open', 
    #     loved: 'icon-heart', 
    #     owned: 'icon-home', 
    #     queued: 'icon-pushpin'}   
    return content_tag(:i,nil,  :class => icons[action]) unless current_user

    url = update_user_film_path(current_user, action, film.id)
   
    actioned = current_user.film_actioned?(film, action)
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



  def poster(film, size='w154')
    size = size ? size : 'w154'
    src = film.has_poster? ? film.poster(size) : "http://placehold.it/#{size.slice(1..-1)}&text=#{film.title}"
    image_tag src, :title=>film.title, alt: "poster for #{film.title}", :class=>'small'
  end

  def poster_link(film, size='w154')
    link_to film_path(film), title: film.title do
      poster film, size
    end
  end
  
  def backdrop(film, backdrop, size = 'w1280')
    image_tag AppConfig.image_uri_for([size, backdrop['file_path']]), title: film.title, alt: "backdrop for #{film.title}"
  end

  def backdrop_link(film, backdrop, size = 'w1280')
    link_to film_path(film), title: film.title do
      backdrop film, backdrop, size
    end
  end


  def trailer(film)
    return unless film.has_trailer?
    src = "http://www.youtube.com/embed/#{film.trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
    content_tag :iframe, nil, src: src, frameborder: 0, allowfullscreen: true
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

  def release_date(film)
    film.release_date ? "#{Date.parse(film.release_date).year}" : ''
  end

end
