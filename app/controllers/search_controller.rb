class SearchController < ApplicationController
  
  respond_to :html, :json, :js
  
  def index
    
  end

  def show
  end

  def query
    params[:query]
  end

  def searcher
    @searcher ||= Searcher.new query, page_no
  end

  helper_method :searcher

end
