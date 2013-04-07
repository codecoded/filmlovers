class FilmsRepository

  def self.top_for(list_name, count=10)
    Film.find Films[list_name].films(count-1)
  end

  def self.films_by(film_ids, order, by=:asc, count=0)
    Film.only(:poster_path, :name, :title, :release_date).order_by([order, by]).limit(count).find(film_ids)
  end
end