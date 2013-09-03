class SearchController < ApplicationController
  
  respond_to :html, :json, :js
  
  def index
    @results = page_results apply_film_filters(Film.search(query)), :title 
    render layout:nil if request.xhr?   
  end

  def show
  end

  def smart
    page_size = 30
    @results = page_results searcher.search, :title

    render json:[
      {
        header: {
          title: 'films search',
          num: page_size,
          limit: @results.count
        },
        data:   @results.map do |film|
          {
            primary: film.title,
            secondary: film.release_date
          }
        end
        }
      ]
  end

  def query
    params[:q]
  end

  def searcher
    @searcher ||= Searcher.new(query)
  end

end
