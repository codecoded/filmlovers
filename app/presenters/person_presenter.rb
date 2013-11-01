class PersonPresenter < BasePresenter
  extend Forwardable

  presents :person

  def_delegators :person, :name, :has_profile?, :id, :biography, :portfolio, :place_of_birth, :profile


  # def films
  #   @films ||= person.credits['cast'].map {|f| Film.new(f)}
  # end

  def short_bio
    shorten biography
  end

  def dob
    person.birthday.to_date.strftime('%B %d, %Y') if person.birthday
  end

  def films_starred_in
    @films_starred_in ||= films_for('cast').compact
  end

  def films_worked_on
    @films_worked_on ||= films_for('crew').compact
  end  

  # def films_for(role)
  #   person.credits[role].map do |film_details| 
  #     movie = Tmdb::Movie.new(film_details)
  #     next if movie.not_allowed?
  #     next unless film = Film.find(movie.title_id)
  #     film.details = film_details 
  #     FilmPresenter.new(film, self)
  #   end
  # end

  def films_for(role)
    person.credits[role].map do |film_details| 
      movie = Tmdb::Movie.new(film_details)
      next if movie.not_allowed?
      next unless film = Film.find(movie.title_id)
      {
        film_presenter: FilmPresenter.new(film, self),
        character: film_details['character'],
        department: film_details['department'],
        job: film_details['job']
      }
    end
  end

  # def create_presenter(film_details)
  #   @similar = similar_movies.map  do |f| 
  #     film = Tmdb::Movie.new(f)
  #     film unless film.not_allowed?
  #   end

  #   Film.find @similar.compact.map(&:title_id)
  #   return unless main_film = Film.find(film_details['id'])
  #   film = Film.new(film_details) 
  #   film.counters = main_film.counters 
  #   FilmPresenter.new(film, self)
  # end
end