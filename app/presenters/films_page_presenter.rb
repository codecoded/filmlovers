class FilmsPagePresenter

  attr_reader :user, :results_page, :description

  def initialize(user, results_page, description='')
    @user, @results_page, @description = user, results_page, description
  end

  def films
    @films ||= results_page.results.map {|result| FilmPresenter.new(user, result)}
  end
end