class FilmController < ApplicationController

  def show
    @film = FilmPresenter.new current_user, Film.find(params[:id])
  end

end
