class FilmsRepository

  def self.top_for(action, count=10)
    top_films = Films[action].group_by(&:film_id).map{|film_id, films| {id: film_id, score: films.length}}.take(count).map {|film| film[:id]}

    Film.only(:poster_path, :name, :title, :release_date).find top_films
  end

  def self.films_by(film_ids, order, by=:asc, count=0)
    Film.only(:poster_path, :name, :title, :release_date).order_by([order, by]).limit(count).find(film_ids)
  end
end