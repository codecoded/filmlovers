class FilmPresenter < BasePresenter
  extend Forwardable

  presents :film


  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?, :has_trailer?, :year, :director

  def film_entry
    @film_entry ||= current_user.films.find film
  end

  def film_actions
    @film_actions ||= film_entry.actions
  end

  def action_list_item(action, text, is_counter = false)
    actioned = user_actioned? action
    action_css = actioned ? 'complete' : nil 
    url = current_user ? film_action_path(film, action) : '#'
    method =  actioned ? :delete : :put
    css = "#{action} #{action_css}"  
    content_tag :li, :class => css  do
      if is_counter
        link_to text, url, data: {'method-type'=> method, "film-action"=>  action,  id: film.id, counter: "#{film.id}_#{action}" }
      else
        link_to text, url, data: {'method-type'=> method, "film-action"=> action,  id: film.id }
      end
    end
  end

  def user_actioned?(action)
    current_user and film_entry ? film_actions.actioned?(action) : false
  end

  def release_date
    film.release_date.strftime('%d %B %Y') if film.release_date
  end

  def classification
    film.classification
  end

  def trailer
    "http://www.youtube.com/embed/#{film.trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
  end

  def iframe_for(trailer)
    content_tag :iframe, nil, src: trailer, frameborder: 0, allowfullscreen: true
  end

  def blank_poster
    image_tag "placeholder.jpg", :title=>film.title, alt: "poster for #{film.title}"
  end

  def poster_sizes
    @poster_sizes  ||= {small: 'w90', medium: 'w185', large: 'w342', original: 'original'}
  end

  def backdrop_sizes
    @backdrop_sizes  ||= {small: 'w300', medium: 'w780', large: 'w1280', original: 'original'}
  end

  def poster_uri(size=:medium)
    return film.poster if (film.poster =~ /http/)
    AppConfig.image_uri_for [poster_sizes[size], film.poster] if film.poster?
  end

  def poster
    return blank_poster unless film.poster?
    image_src = case film.provider.to_sym.downcase
      when :tmdb then poster_uri
      else film.poster
    end

    image_tag image_src, :title=>film.title, alt: "poster for #{film.title}"
  end

  def backdrop_uri(size=:original)
    return film.backdrop if (film.backdrop =~ /http/)
    AppConfig.image_uri_for [backdrop_sizes[size], film.backdrop] if film.backdrop?
  end

  def poster_link
    link_to poster, film_path(film), title: film.title
  end

  def counter(action)
    film_counters[action]
  end

  def film_counters
    @film_counters ||= if film.counters.new_record?
        Film.find(film.id).counters
      else
        film.counters
      end
  end

  def provider_links
    film.providers.map do |p|
      {
        id: p.id,
        name: p.name,
        link: p.link,
        rating: p.rating
      }
    end
  end




end