module FilmScopes
  extend self

  def invalid
    self.or({release_date: nil}, {_id: /^-/})
  end

  def adult
    where('details.adult' => true)
  end

  def find_by_provider(name, id)
    find_by('providers.name'=> name, 'providers._id' => id)
  end

  def by_provider(name)
    where('providers.name'=> name)
  end

  def by_decade(decade)
    endDate = Date.new(decade.to_i+10)
    where(release_date: Date.new(decade.to_i).to_s..endDate.to_s)
  end

  def by_year(year)
    endYear = Date.new(year.to_i) + (1.year)
    where(release_date: Date.new(year.to_i)...endYear)
  end

  def popular
    where('release_date < ? and popularity > ? and poster is not null', 1.week.from_now, 0.45)
  end

  def by_genres(genres)
    query = genres.split('/').map {|g| " '#{g}' = ANY(genres)"}.join(' AND ')
    where(query)
  end

  def by_counter(name)
    order("#{name}_counter desc")
  end

  def search(query, field=:title)
    where('title ilike ?', "%#{query.strip}%")
  end 

  def recently_actioned(limit)
    sql = "
      SELECT f.* FROM films f
      JOIN 
      (SELECT film_id, ROW_NUMBER() OVER(PARTITION BY film_id ) AS row_number
      FROM film_entries
      ORDER BY updated_at DESC) AS T1
      ON T1.film_id = f.id
      WHERE T1.row_number = 1 AND poster IS NOT NULL
      LIMIT #{limit.to_i}
    "
    Film.find_by_sql sql 
  end

  def in_cinemas
    @in_cinemas = Rotten::Movies.in_cinemas
    @opening    = Rotten::Movies.opening
    (@in_cinemas + @opening).uniq.compact.map &:film
    # ids = Cinema.all.map {|c| c.daily_schedules.current.map {|d| d.show_times.map {|s| s.film_id} }}.flatten.compact.uniq
    # Film.in id: ids
  end

  def coming_soon
    where(release_date: Date.tomorrow.to_s..2.months.from_now.to_date.to_s)
    # Film.elem_match('releases.countries' => {'iso_3166_1'=>'GB', release_date: Time.now.to_date.to_s..2.months.from_now.to_date.to_s})
    # ids ||= Rotten::Movies.opening.map(&:film_id).compact.uniq
    # ids <<  Rotten::Movies.upcoming.map(&:film_id).compact.uniq
    # Film.in id: ids.flatten
  end

  def filter(filters={})
    return scoped if filters.blank? or filters.empty?
    query = scoped
    if filters[:year]
      query = query.by_year filters[:year]
    else
      query = query.by_decade filters[:decade] if filters[:decade]
    end
    query = query.by_genres filters[:genres] if filters[:genres]  
    query    
  end

  def recommendations_view_for(user_id, state=:recommended)
    joins(:recommendations).
    group('films.id').
    where('film_recommendations.friend_id = ? and film_recommendations.state = ?', user_id, state).
    select('films.*, count(film_recommendations.id) as total').
    order('count(*) desc')    
  end

  # def cast_search(name)
  #   Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.cast.name'=>/#{name}/i)
  # end

  # def crew_search(name)
  #   Film.only(:poster_path, :name, :title, :release_date, :trailers).where('casts.crew.name'=>/#{name}/i)
  # end


end