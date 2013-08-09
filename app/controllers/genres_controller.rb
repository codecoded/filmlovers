class GenresController < ApplicationController

  def index
  end
  
  def show
    @films ||= page_results Film.by_genre(genre.name), :popularity
    request.xhr? ? render('show', layout:nil) : render('show')
  end

  protected

  def genre
    @genre ||= Genre.find_by_name params[:id]
  end



  helper_method :genre

end
