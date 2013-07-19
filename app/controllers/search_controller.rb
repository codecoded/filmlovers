class SearchController < ApplicationController
  
  respond_to :html, :json, :js
  
  def index
    @searcher ||= Searcher.new(query)
    @results = page_results @searcher.search, :popularity, :desc 
    render layout:nil if request.xhr?   
  end

  def show
  end

  def query
    params[:query]
  end

  def searcher

  end

end
