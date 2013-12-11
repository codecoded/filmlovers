class ActiveUserQuery


  attr_accessor :page, :sort_by

  def initialize(query, options={} )
    @query, @options = query, options
  end

  def page_size
    @options[:page_size] ? @options[:page_size].to_i : AdminConfig.instance.page_size
  end

  def page
    @page ||= @options[:page] ? @options[:page].to_i : 1
  end

  def results?
    Log.debug __method__
    !results.empty?
  end

  def results_count
    Log.debug __method__
    @results_count ||= all_results.size
  end

  def total_pages
    results? ? (results_count / page_size) + 1 : 1
  end

  def sort_by
    @sort_by ||= @options[:sort_by]
  end

  def all_results
    @all_results ||= @query.order(sort_order)
  end

  def results(options={})
    Log.debug __method__
    @results ||= all_results.page(page).per(page_size)
  end

  def sort_order
    sort_orders[sort_by.to_s]
  end

  def sort_orders
    {
      'username'              =>  :username,
      'title'                 =>  :id, 
      'recent'                =>  'updated_at desc',
      'recent_action'         =>  'created_at desc',
      'release_date'          =>  'release_date desc',
      'earliest_release_date' =>  :release_date,
      'popularity'            =>  'coalesce(popularity,0) desc',
      'watched'               =>  'watched_counter desc',
      'loved'                 =>  'loved_counter desc',
      'owned'                 =>  'owned_counter desc',
      'total'                 =>  'total desc'
    }
  end

end