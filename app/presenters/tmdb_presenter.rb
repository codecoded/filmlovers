class  TmdbPresenter < BasePresenter
  extend Forwardable

  presents :film_details


  def film
    @film ||= film_details.film
  end

  def title_with_year
    "#{film.title} - #{film.year}"
  end

  def year_and_director
    if !director.blank?
      ("#{film.year} - Directed by " << link_to(director.name, person_path(director.id))).html_safe
    else
      film.year
    end
  end


  def images?
    film_details.images
  end

  def images_library
    @images = Images.new(film_details.images) if images?
  end

  def poster_sizes
    @poster_sizes  ||= {small: 'w90', medium: 'w154', large: 'w342', original: 'original'}
  end

  def posters
    images_library ? images_library.posters : []
  end

  def posters?
    !posters.blank?
  end

  def poster(size=:medium)
    src = film.poster? ? poster_uri(film.poster, size) : "placeholder.jpg"
    image_tag src, :title=> film.title, alt: "poster for #{film.title}"
  end

  def poster_uri(poster=nil, size=:medium)
    AppConfig.image_uri_for [poster_sizes[size], poster || film.poster] if film.poster?
  end

  def posters_urls_for(size=:medium)
    posters.map {|p| poster_uri(p['file_path'], size)} if posters?
  end

  def poster_link(size=:medium)
    link_to film_path(film), title: film.title do
      poster size
    end
  end

  def backdrop_sizes
    @backdrop_sizes  ||= {small: 'w90', medium: 'w185', large: 'w342', original: 'original'}
  end

  def backdrops?
    !backdrops.blank?
  end

  def backdrops
    images_library ? images_library.backdrops : []
  end

  def backdrop_uri(size='original')
    AppConfig.image_uri_for([size, backdrops[0]['file_path']]) if backdrops?
  end

  def backdrop(backdrop, size = 'w1280')
    return unless backdrop
    image_tag AppConfig.image_uri_for([size, backdrop['file_path']]), title: film.title, alt: "backdrop for #{film.title}"
  end


  def backdrops_urls_for(size)
    backdrops.map {|b| AppConfig.image_uri_for [size, b['file_path']] } if backdrops?
  end

  def homepage
    film_details.homepage
  end

  def main_backdrop(size = 'w1280')
    backdrop(backdrops[0]) if backdrops? 
  end

  def alternative_titles
    film_details.alternative_titles.map {|t| t['title']}
  end
  
  def overview(length=nil)
    if length
      truncate film_details.overview, separator: ' ', length: length, :omission => '...'
    else
      film_details['overview']
    end
  end

  def cast
    film_details.credits.cast.map do |person|

    end
  end

  
  def runtime
    "#{film_details.runtime} Mins" if film_details.runtime and film_details.runtime > 0
  end

  def status
    film_details.status if film_details.status != 'Released'
  end

  def languages?
    film_details.spoken_languages
  end


  def languages
    film_details.spoken_languages.map {|l| l['name']} if languages?
  end

  def release_date
    film.release_date.strftime('%d %B %Y')
  end

  def budget
    return unless film_details.budget and film_details.budget > 0
    Utilities.to_currency film_details.budget ,{precision: 0}
  end

  def original_title
    film_details.original_title if film_details.original_title != film_details.title
  end

  def rating
    film.classification
  end

  def youtube_trailers
    return unless film.trailer? and film_details.trailers
    film_details.trailers['youtube'].map {|t| t['source'] }.select {|s| !s.start_with? 'http'} 
  end

 def youttube_url_for(trailer)
    "http://www.youtube.com/embed/#{trailer}?iv_load_policy=3&modestbranding=1&origin=localhost&rel=0&showinfo=0&controls=1"
  end

  def iframe_for(trailer)
    content_tag :iframe, nil, src: youttube_url_for(trailer), frameborder: 0, allowfullscreen: true
  end

  def genres
    film_details.genres.map {|g| Genre.find_by_id(g['id'])}
  end

  def other_links
    return if film.providers.empty?

    other = ''
    if imdb = film.provider_for(:imdb)
      other = content_tag :a,  href: "http://www.imdb.com/title/#{imdb.id}",  alt:"IMDB link for #{film.title}", target: '_blank' do 
        image_tag 'imdb_logo.png'
      end
    end

    if netflix = film.provider_for(:netflix)
      other << content_tag(:a,  href: netflix.link,  alt:"Netflix link for #{film.title}", target: '_blank') do 
         image_tag('netflix-n-logo.png') << "#{netflix.rating}<font style='font-size:60%'>/5</font>".html_safe
      end
    end

    if rotten = film.provider_for(:rotten)
      other << content_tag(:a,  href: rotten.link,  alt:"RottenTomatoes link for #{film.title}", target: '_blank') do 
         image_tag('rotten.png') << "#{rotten.rating}".html_safe
      end
    end

    other 
  end

  def tagline
    film_details.tagline
  end

  def starring
    return unless film_details.credits and film_details.credits.cast
    @starring = film_details.credits.cast.take(3).map do |person|
      link_to person.name, person_path(person.id) 
    end
    @starring.join(', ').html_safe
  end

  def character
    film_details['character']
  end

  def department
    film_details['department']
  end

  def job
    film_details['job']
  end

  def counter(action)
    film.counters[action]
  end


  def casts
    @casts ||= film_details['casts']
  end

  def credits
    @credits ||= Credits.new casts if casts
  end

  def director
    @director ||= crew_member 'Director'
  end

  def director?
     director
  end

  # def director
  #   @director ||= crew_member 'Director'
  #   @director ? @director['name'] : ''
  # end

  def crew_member(job)
    return '' unless crew?
    credits.crew.find {|member| member['job']==job}
  end

  def cast?
    credits and !credits.cast.blank?
  end

  def crew?
    credits and !credits.crew.blank?
  end

  def has_trailer?(source=:youtube)
    film_details.trailers and !film_details.trailers[source.to_s].blank?
  end

  def trailer(source=:youtube)
    film_details.trailers[source.to_s][0]['source'] if has_trailer?(source)
  end

  def similar_movies
    @similar_movies ||= film_details.similar_movies['results'] || {}
  end

  def similar?
    !similar_movies.empty?
  end

  def similar
   @similar = similar_movies.map  do |f| 
      film = Tmdb::Movie.new(f)
      film unless film.not_allowed?
    end

    Film.find @similar.compact.map(&:title_id)
  end

  def starring(count=3)
    credits.cast.take(count).map(&:name) if credits
  end

  def alternative_titles
    presenter.alternative_titles['titles'] if alternative_titles?
  end

  def alternative_titles?
    film.details.alternative_titles
  end

  def studios
    @studios ||= film_details.production_companies
  end

  def studios?
    !studios.blank?
  end

  def locations
    @locations ||= film_details.production_countries
  end

  def locations?
    !locations.blank?
  end

  def genres?
    film_details.genres
  end

  def duration
    film_details.runtime if film_details.runtime and film_details.runtime.to_i > 0  
  end

  def popularity
    film_details.popularity
  end

end