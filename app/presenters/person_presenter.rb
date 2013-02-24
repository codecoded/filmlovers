class PersonPresenter
  extend Forwardable

  attr_reader :user, :person, :thumbnail_size

  def_delegators :person, :name, :has_profile?, :id, :biography, :portfolio

  def initialize(user, person, thumbnail_size='w185')
    @user, @person, @thumbnail_size = user, person, thumbnail_size
  end

  def films
    @films ||= person.credits['cast'].map {|f| FilmPresenter.new user, Film.new(f), 'w92'}
  end

end