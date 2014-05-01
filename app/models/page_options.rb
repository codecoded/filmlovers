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

  def filters_desc
    return '' unless !film_filters.empty?

    text = []
    text << ("year '#{film_filters[:year]}'") if film_filters[:year].to_i > 0
    text << ("decade '#{film_filters[:decade]}'") if film_filters[:decade].to_i > 0

    text << ("genres '#{film_filters[:genres].capitalize}'") if !film_filters[:genres].blank?

    " filtered by " + text.join(', ')
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