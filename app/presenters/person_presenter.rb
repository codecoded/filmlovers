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
    person.credits['cast'].map {|film| FilmPresenter.new(Film.new(film), self)}
  end

  def films_worked_on
    person.credits['crew'].map {|film| FilmPresenter.new(Film.new(film), self)}
  end  
end