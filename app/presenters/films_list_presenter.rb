class FilmsListPresenter
  extend Forwardable

  attr_reader :user, :films_list, :films_from_queue

  def_delegators :films_list, :name, :description, :id

  def initialize(user, films_list, films_from_queue=nil)
    @user, @films_list, @films_from_queue = user, films_list, films_from_queue
  end

  def films
    @films_presenters ||= FilmPresenter.from_films user, films_list.films
  end

end