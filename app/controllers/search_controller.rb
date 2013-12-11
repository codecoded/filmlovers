class SearchController < ApplicationController
  
  respond_to :html, :json, :js
  
  def index
    @results = create_query(sort_by: :title).results
    render layout:nil if request.xhr?   
  end

  def show
  end

  def smart
    @query = create_query(sort_by: :title, page_size: 30)

    render json:[
      {
        header: {
          title: 'films search',
          num: 30,
          limit: @query.results_count
        },
        data:   @query.results.map do |film|
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

  protected

  def create_query(options)
    options = paging_options options
    search_query = Film.filter(film_filters).search(query)
    ActiveUserQuery.new(search_query, options)    
  end
end
