class FilmEntryPresenter < BasePresenter
  extend Forwardable

  presents :film_entry

  def_delegators :film_entry, :film, :user
  def_delegators :film_presenter, :poster, :title, :poster_uri, :director, :backdrop_uri

  def film_presenter
    @film_presenter ||= FilmPresenter.new(film, @template)
  end

  def rating_count
    @rating_count = film.entries.count
  end

  def loved
    counter_for :loved
  end

  def watched
    counter_for :watched
  end

  def filmlovr_rating
    loved_count = (loved > watched ? watched : loved)
    return 0 if watched <= 0 
    ((loved_count / watched.to_f) * 100.0).round
  end


  def self.from_films(films, template)

    current_user = template.current_user

    entries = {}
    if current_user
      return films.map {|film| new(film.entries.new, template)}
    end

    current_user.film_entries.where(film_id: films.map(&:id)).each {|fe| entries[fe.film_id] = fe}

    films.map do |film|
      entry = entries[film.id] || film.entries.new(user_id:current_user.id)
      new(entry, template)
    end

  end

  def counter_for(action)
    film.send "#{action}_counter"
  end

  def not_logged_in_action(action)
    {
      css: action,
      url: "#",
      method: :put
    }
  end

  def own_films?
    user.id == current_user.id if current_user
  end

  def logged_in_action(action)
    if !own_films?
      user_film_entry = current_user.film_entry_for(film.id) 
    else
      user_film_entry = film_entry
    end

    if user_film_entry.set?(action)
      {
        css: "#{action} complete"  ,
        url: film_action_path(film, action),
        method: :delete
      }
    else
      {
        css: action,
        url: film_action_path(film, action),
        method: :put
      }
    end
  end

  def action_list_item(action, text)
    options = current_user ? logged_in_action(action) : not_logged_in_action(action)

    data = {
      'method-type'=> options[:method],
      "film-action"=> action,
      id: film.id
    }

    content_tag :li, :class => options[:css]  do
      link_to text, options[:url], data: data
    end
  end

  # def action_list_item(action, text, is_counter = false)
  #   actioned = user_actioned? action
  #   action_css = actioned ? 'complete' : nil 
  #   url = current_user ? film_action_path(film, action) : '#'
  #   method =  actioned ? :delete : :put
  #   css = "#{action} #{action_css}"  
  #   content_tag :li, :class => css  do
  #     if is_counter
  #       link_to text, url, data: {'method-type'=> method, "film-action"=>  action,  id: film.id, counter: "#{film.id}_#{action}" }
  #     else
  #       link_to text, url, data: {'method-type'=> method, "film-action"=> action,  id: film.id }
  #     end
  #   end
  # end


  def counter_links
    [:watched, :loved, :owned].map do |action|
      counter_link action
    end
  end

  def counter_link(action)
    options = current_user ? logged_in_action(action) : not_logged_in_action(action)

    data = {
      'method-type'=> options[:method],
      "film-action"=> action,
      id: film.id,
      counter: "#{film.id}_#{action}"
    }

    text = counter_for action

    content_tag :li, :class => options[:css]  do
      link_to text, options[:url], data: data
    end
  end


end