module UserScopes
  extend self

  def search(query)
    self.where('username ilike ?', query)
  end 

  # def filter(filters={})
  #   return self if filters.blank?
  #   query = self
  #   query.without(:films_lists)    
  # end

  def self.page_results(sort_order, page_size=AdminConfig.instance.page_size)
    order(sort_order).page(page_no).per page_size
  end

  def recommendations_view_for(user_id, state=:recommended)
    joins(:film_recommendations).group('users.id').where('film_recommendations.friend_id = ? and film_recommendations.state = ?', user_id, :recommended).select('users.*, count(film_recommendations.id)')
  end

  # def cast_search(name)
  #   Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.cast.name'=>/#{name}/i)
  # end

  # def crew_search(name)
  #   Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.crew.name'=>/#{name}/i)
  # end


end