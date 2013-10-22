module UserScopes
  extend self

  def search(query)
    self.where({username: /#{query}/i})
  end 

  # def filter(filters={})
  #   return self if filters.blank?
  #   query = self
  #   query.without(:films_lists)    
  # end

  def self.page_results(sort_order, page_size=AdminConfig.instance.page_size)
    order_by(sort_order).page(page_no).per page_size
  end

 

  # def cast_search(name)
  #   Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.cast.name'=>/#{name}/i)
  # end

  # def crew_search(name)
  #   Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.crew.name'=>/#{name}/i)
  # end


end