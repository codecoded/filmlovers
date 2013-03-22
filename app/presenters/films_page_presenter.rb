class FilmsPagePresenter
  extend Forwardable

  attr_reader :user, :results_page, :description
  attr_accessor :films

  def_delegators :results_page, :page_no, :total_pages, :results

  def initialize(user, results_page, description='')
    @user, @results_page, @description = user, results_page, description
  end

  def films
    @films ||= results.map {|film| FilmPresenter.new user, film}
  end

  def next_params
    next? ? {page: page_no+1} : {}
  end

  def previous_params
    previous? ? {page: page_no-1} : {}
  end

  def next?
    page_no < total_pages
  end

  def previous?
    page_no > 1
  end
end