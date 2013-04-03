require 'results_page'
class TrendsController < ApplicationController


  def show
    cache_key = "trend_#{trend}_page_" + (params[:page] || '')
    results = Rails.cache.fetch cache_key do
      results = TmdbFilmsSearch.new.by_trend trend, page_options
    end
    present(results, trend)
  end

  protected

  def page_options
    params[:page] ? {page: params[:page].to_i} : {} 
  end

  def present(results_page, description='')
    @films_page = FilmsPagePresenter.new(current_user, results_page, description)
  end

  def trend
    params[:id]
  end

  def page_no
    params[:page] || 1
  end

  helper_method :trend, :page_no

end
