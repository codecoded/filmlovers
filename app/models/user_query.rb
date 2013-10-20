class UserQuery


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
    !results.empty?
  end

  def results_count
    @results_count ||= all_results.count
  end

  def total_pages
    results? ? (results_count / page_size) + 1 : 1
  end

  def sort_by
    @sort_by ||= @options[:sort_by]
  end

  def all_results
    @all_results ||= @query.order_by(sort_order).without(@options[:without])
  end

  def results(options={})
    all_results.page(page).per(page_size)
  end

  def sort_order
    sort_orders[sort_by.to_s]
  end

  def sort_orders
    {
      'username'              =>  [:username, :asc],
      'title'                 =>  [:_id, :asc], 
      'recent'                =>  [:updated_at, :desc],
      'recent_action'         =>  ['actions.updated_at', :desc],
      'release_date'          =>  [:release_date, :desc],
      'earliest_release_date' =>  [:release_date, :asc],
      'popularity'            =>  [:popularity, :desc],
      'watched'               =>  ['counters.watched', :desc], 
      'loved'                 =>  ['counters.loved', :desc],
      'owned'                 =>  ['counters.owned', :desc] 
    }
  end

end