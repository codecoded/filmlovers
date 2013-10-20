module Queryable

  def query_with(options={})
    order(options[:sort_by]).
    page(options[:page] || 1).
    per(options[:page_size] || AdminConfig.instance.page_size)
  end

  def order(key)
    order_by(sort_orders[key.to_s])
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