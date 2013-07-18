module Films
  extend self

  FilmLists = [:watched, :loved, :unloved, :owned]

  def [](action)
    FilmUserAction[action]
  end

  def count_for(action)
    self[action].count
  end

  def actioned(action,count=0)
    ids = Films[action].
          order_by([:updated_at.desc]).
          group_by(&:film_id).
          map{|film_id, films| {id: film_id, score: films.length}}.
          take(count).map {|film| film[:id]}
    Film.only(:poster_path, :name, :title, :release_date).find ids
  end

  def recently_actioned(action,count=0)
    ids = Films[action].
          order_by([:updated_at.desc]).
          group_by(&:film_id).
          map{|film_id, actions| {id: film_id, score: actions.length}}.
          take(count).map {|film| film[:id]}
    find_all_summaries ids
  end

  def recent(count=5)
    ids = FilmUserAction.
        order_by([:updated_at.desc]).
        group_by(&:film_id).
        map{|film_id, actions| {id: film_id, score: actions.length}}.
        take(count).
        map {|film| film[:id]}
    find_all_summaries ids
  end

  def adult
    Film.where(adult: true)
  end

  def invalid
    Film.or({release_date: nil}, {:release_date.exists => false}, {release_date: ''})
  end

  def find_all_summaries(ids)
    Film.only(:poster_path, :name, :title, :release_date, :trailers).find ids
  end

  def paged_actioned(action, order=:release_date, by = :desc, page_no = 0, page_size = 20)
    film_ids = Films[action].map &:film_id
    results = Films.films_by(film_ids, :release_date, :desc).slice(page_no * page_size, page_size)
    ResultsPage.new results || {}, film_ids.count, page_size, page_no
  end

  def top_for(action, count=10)
    top_films = Films[action].
      group_by(&:film_id).
      map{|film_id, films| {id: film_id, score: films.length}}.
      sort_by {|x| x[:score]}.
      reverse.
      take(count).
      map {|film| Film.only(:poster_path, :name, :title, :release_date, :backdrop_path, :images, :trailers).find film[:id]}
      # map {|film| film[:id]}

    # Film.only(:poster_path, :name, :title, :release_date, :backdrop_path, :images).find top_films
  end

  def films_by(film_ids, order, by=:asc, count=0)
    Film.only(:poster_path, :name, :title, :release_date, :trailers).order_by([order, by]).limit(count).find(film_ids)
  end

  def search(query, field=:title, order=:title, by=:asc)
    Film.order_by([order, by]).where(field => /\b#{query}\b/i)
  end

  def cast_search(name)
    Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.cast.name'=>/#{name}/i)
  end

  def crew_search(name)
    Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.crew.name'=>/#{name}/i)
  end

  def in_cinemas
    ids ||= Rotten::Movies.in_cinemas.map(&:film_id).compact.uniq
    # ids = Cinema.all.map {|c| c.daily_schedules.current.map {|d| d.show_times.map {|s| s.film_id} }}.flatten.compact.uniq
    Film.in id: ids
  end

  def coming_soon
    Film.elem_match('releases.countries' => {'iso_3166_1'=>'GB', release_date: Time.now.to_date.to_s..2.months.from_now.to_date.to_s})
    # ids ||= Rotten::Movies.opening.map(&:film_id).compact.uniq
    # ids <<  Rotten::Movies.upcoming.map(&:film_id).compact.uniq
    # Film.in id: ids.flatten
  end

  def popular
  end


end