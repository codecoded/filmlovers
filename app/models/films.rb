class Films
  FilmLists = [:watched, :loved, :unloved, :owned]

  def self.[](action)
    FilmUserAction[action]
  end

  def self.count_for(action)
    self[action].count
  end

  def self.actioned(action,count=0)
    ids = Films[action].
          order_by([:updated_at.desc]).
          group_by(&:film_id).
          map{|film_id, films| {id: film_id, score: films.length}}.
          take(count).map {|film| film[:id]}
    Film.only(:poster_path, :name, :title, :release_date).find ids
  end

  def self.recently_actioned(action,count=0)
    ids = Films[action].
          order_by([:updated_at.desc]).
          group_by(&:film_id).
          map{|film_id, actions| {id: film_id, score: actions.length}}.
          take(count).map {|film| film[:id]}
    find_all_summaries ids
  end

  def self.recent(count=5)
    ids = FilmUserAction.
        order_by([:updated_at.desc]).
        group_by(&:film_id).
        map{|film_id, actions| {id: film_id, score: actions.length}}.
        take(count).
        map {|film| film[:id]}
    find_all_summaries ids
  end

  def self.find_all_summaries(ids)
    Film.only(:poster_path, :name, :title, :release_date, :trailers).find ids
  end


  def self.paged_actioned(action, order=:release_date, by = :desc, page_no = 0, page_size = 20)
    film_ids = Films[action].map &:film_id
    results = FilmsRepository.films_by(film_ids, :release_date, :desc).slice(page_no * page_size, page_size)
    ResultsPage.new results || {}, film_ids.count, page_size, page_no
  end


end