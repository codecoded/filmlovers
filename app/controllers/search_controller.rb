class SearchController < ApplicationController
  
  respond_to :html, :json, :js
  
  def index
    @results = page_results searcher.search, :popularity 
    render layout:nil if request.xhr?   
  end

  def show
  end

  def smart
    page_size = 50
    @results = page_results searcher.search, :popularity  , :desc, page_size

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
            secondary: film.uk_release_date,
            image: (film.poster('w45') if film.has_poster?)
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
