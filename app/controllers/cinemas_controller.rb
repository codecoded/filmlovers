class CinemasController < ApplicationController

  def index
   
  end

  def now_playing
    @films = Film.now_playing.sort_by(&:release_date).reverse
    
  end

  protected

  def cinemas
    Cinema.all
  end

  def cinema
    @cinema ||= cinemas.find(params[:id])
  end

  def daily_schedules
    @daily_schedules ||= cinema.daily_schedules
  end


  helper_method :cinemas, :cinema, :daily_schedules
end
