class FilmController < ApplicationController

  def show
    @film_view = FilmPresenter.new current_user, Film.fetch(params[:id])
  end

end
