class FilmsListPresenter
  extend Forwardable

  attr_reader :user, :films_list, :films_from_queue

  def_delegators :films_list, :name, :description

  def initialize(user, films_list, films_from_queue=nil)
    @user, @films_list, @films_from_queue = user, films_list, films_from_queue
  end

end