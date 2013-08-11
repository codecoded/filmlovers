class PersonPresenter < BasePresenter
  extend Forwardable

  presents :person

  def_delegators :person, :name, :has_profile?, :id, :biography, :portfolio


  def films
    @films ||= person.credits['cast'].map {|f| Film.new(f)}
  end

  def short_bio
    shorten biography
  end

  def dob
    person.birthday.to_date.strftime('%B %d, %Y') if person.birthday
  end

  def films_starred_in
    @films_starred_in ||= films_for('cast')
  end

  def films_worked_on
    @films_worked_on ||= films_for('crew')
  end  

  def films_for(role)
    person.credits[role].map {|film| create_presenter(film)}.compact
  end

  def create_presenter(film_details)
    return unless main_film = Film.fetch(film_details['id'])
    film = Film.new(film_details) 
    film.counters = main_film.counters 
    FilmPresenter.new(film, self)
  end
end