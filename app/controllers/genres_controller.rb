class GenresController < ApplicationController

  def index
  end
  
  def show
    results = TmdbFilmsSearch.new.by_genre genre.id, page_options
    present(results, params[:genre_id]) 
  end


  protected

  def page_options
    params[:page] ? {page: params[:page].to_i} : {} 
  end

  def present(results_page, description='')
    @films_page = FilmsPagePresenter.new(current_user, results_page, description)
  end

  def genre
    Genres.find_by_name params[:id]
  end

  def page_no
    params[:page] || 1
  end

  helper_method :genre, :page_no

end
