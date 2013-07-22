class FilmPresenter < BasePresenter
  extend Forwardable

  presents :film


  def_delegators :film, :title, :has_poster?, :id, :has_backdrop?, :has_trailer?, :overview, :score


  def self.icons
    @icons ||= {
      watched:  'icon-eye-open', 
      loved:    'icon-heart', 
      owned:    'icon-home', 
      queued:   'icon-pushpin',
      list:     'icon-list'
    }
  end


  def title_with_year
    "#{film.title} " << year
  end

  def year
    return "" unless film.year
    "(#{film.year})"
  end

  def year_and_director
    # ("#{film.year} - Directed by " << link_to(film.director, person_path(film.director))).html_safe
     "#{film.year} - Directed by #{film.director}"
  end

  def alternative_titles
    film.alternative_titles.map {|t| t['title']}
  end
  
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

  def cast
    film.credits.cast.map do |person|

    end
  end

  def action_list_item(action, text)
    return content_tag(:li,nil,  :class => icons[action]) unless current_user
    actioned = user_actioned? action
    action_css = actioned ? 'complete' : nil 
    url = update_user_film_path(current_user, action, film)
    method =  actioned ? :delete : :put
    css = "#{action} #{action_css}"  
    content_tag :li, :class => css  do
      link_to text, url, data: {method: method, action: action, remote: true, id: film.id }
    end
  end

  def action_icon(action)
 
    return content_tag(:i,nil,  :class => icons[action]) unless current_user

    url = update_user_film_path(current_user, action, film)
   
    actioned = user_actioned? action
    method =  actioned ? :delete : :put
    action_css = actioned ? 'actioned' : 'unactioned' 
    css = "#{icons[action]} #{action_css}"  
    content_tag :i, nil, :class => css, data: {href: url, method: method, action: action, remote: true, id: film.id } 
  end

  def icons
    FilmPresenter.icons
  end

  def user_actioned?(action)
    current_user ? user_actions.include?(action) : false
  end

  def runtime
    film.runtime || 0 > 0 ? "#{film.runtime} Mins" : "-- Mins"
  end

  def similar_films
    film.similar.map do |film|
      {
        url: film_path(film),
        title: film.title
      }
    end
  end

  def status
    film.status if film.status != 'Released'
  end

  def languages
    film.spoken_languages.map {|l| l['name']}
  end

  # def actioned?(action)
  #   return false unless user
  #   user.film_actioned? film, action
  # end

  # def stats(action)
  #   film.users[action].count
  # end

  # def thumbnail(size='w154')
  #   size = size ? size : 'w154'
  #   has_poster? ? film.poster(size ? size : thumbnail_size) : "http://placehold.it/#{size.slice(1..-1)}&text=#{film.title}"
  # end

  # def backdrop(size='original')
  #   film.backdrop(size)
  # end

  def release_date
    film.uk_release_date.to_date.strftime('%d %B %Y') if film.release_date
  end

  def budget
    return unless film.budget and film.budget > 0
    Utilities.to_currency film.budget ,{precision: 0}
  end

  def original_title
    film.original_title if film.original_title != film.title
  end

  def rating
    film.uk_certification
  end

  def youtube_trailers
    return unless film.has_trailer?
    film.trailers['youtube'].map {|t| t['source'] }.select {|s| !s.start_with? 'http'} 
  end

 def youttube_url_for(trailer)
    "http://www.youtube.com/embed/#{trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
  end

  def iframe_for(trailer)
    content_tag :iframe, nil, src: youttube_url_for(trailer), frameborder: 0, allowfullscreen: true
  end

  def genres
    film.genres.map {|g| Genre.cached.find(g['id'])}
  end

  def imdb_link
    return unless film.imdb_id
    content_tag :a,  href: "http://www.imdb.com/title/#{film.imdb_id}",  alt:"IMDB link for #{film.title}", target: '_blank' do 
      image_tag 'imdb_logo.png'
    end
  end

  # def director
  #   @director ||= film.credits.crew.find {|member| member['job']=='Director'}
  #   @director ? @director['name'] : ''
  # end

  # def year
  #   @year ||= (Date.parse(film.release_date).year if film.release_date)
  # end

  # def similar_films?
  #   film.similar_movies
  # end

  # def similar_films
  #   return unless similar_films?
  #   film.similar_movies['results'].compact.map {|f| FilmPresenter.new user, Film.new(f), 'w92'}
  # end


end