class FilmPresenter < BasePresenter
  extend Forwardable

  presents :film


  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?, :has_trailer?, :year

  def user_actions
    @user_actions ||= current_user.film_user_actions.where(film: film).distinct(:action)
  end

  def film_action_counter(action)
    action_css = user_actioned?(action) ? 'actioned' : 'unactioned'
    css = "#{icons[action]} #{action_css}"
    content_tag :i, nil,:class => css, data: {action: action, id: film.id}
  end

  def action_count(action)
    film.actions_for(action).count
  end

  def action_list_item(action, text, is_counter = false)
    actioned = user_actioned? action
    action_css = actioned ? 'complete' : nil 
    url = current_user ? update_user_film_path(current_user, action, film) : '#'
    method =  actioned ? :delete : :put
    css = "#{action} #{action_css}"  
    content_tag :li, :class => css  do
      if is_counter
        link_to text, url, data: {'method-type'=> method, action: action,  id: film.id, counter: "#{film.id}_#{action}" }
      else
        link_to text, url, data: {'method-type'=> method, action: action,  id: film.id }
      end
    end
  end

  def user_actioned?(action)
    current_user ? user_actions.include?(action) : false
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

  def poster
    return blank_poster unless film.poster?

    image_src = case film.details_provider.to_sym
      when :tmdb then AppConfig.image_uri_for ['w185', film.poster]
      else film.poster
    end

    image_tag image_src, :title=>film.title, alt: "poster for #{film.title}"
  end

  def poster_link
    link_to poster, film_path(film), title: film.title
  end

  def counter(action)
    film.counters[action]
  end

end