class FilmsListPresenter
  extend Forwardable

  attr_reader :films_list, :films_to_add

  def_delegators :films_list, :name, :description, :id

  def initialize(films_list, films_to_add=[])
    @films_list = films_list 
    @film_ids = films_list.film_ids + films_to_add 
  end

  def user
    @user ||= films_list.user
  end
  
  def self.from_queue(user, film_ids)
    new user.films_lists.new, film_ids
  end

  def films
    @films_presenters ||= FilmPresenter.from_film_ids user, @film_ids
  end

end