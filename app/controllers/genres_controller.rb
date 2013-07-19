class GenresController < ApplicationController

  def index
  end
  
  def show
    @films ||= page_results Films.by_genre(genre.name), :popularity, :desc
  end

  protected

  def genre
    @genre ||= Genre.find_by_name params[:id]
  end



  helper_method :genre

end
