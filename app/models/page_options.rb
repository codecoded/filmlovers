module PageOptions

  def paging_options(defaults={})
    {
      sort_by:    sort_by              || defaults[:sort_by],
      page:       page                 || defaults[:page],
      page_size:  defaults[:page_size] || page_size
    }
  end


  def film_filters(defaults={})
    {
      year:   params[:year]   || defaults[:year],
      decade: params[:decade] || defaults[:decade],
      genres: params[:genres] || defaults[:genres]
    }.reject{|k,v| v==nil}
  end

  def user_filters
    {}
  end

  def sort_by
    @sort_by ||= params[:sort_by]
  end

  def page
    @page ||= params[:page] ? params[:page].to_i : 1
  end

  def page_size
    @page_size ||= AdminConfig.instance.page_size 
  end

  def year
    @year ||= params[:year]
  end

  def decade
    @decade ||= params[:decade]
  end

  def genres
    @genres ||= params[:genres]
  end




end