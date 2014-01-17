class Person
  include Mongoid::Document

  field :_id, type: String, default: ->{ id }
  field :fetched, type: DateTime, default: nil
  
  # has_many :recommendations, as: :recommendable

  def self.fetch(id)
    PersonRepository.find id
  end
  

  def portfolio
    @credits ||= Credits.new credits
  end

  # def films
  #   return unless portfolio and portfolio.cast
  #   portfolio.cast.collect {|film| film['id'] }
  # end

  def films
    cast_films_id = credits['cast'].map {|film| film['id']}.compact
    crew_films_id = credits['crew'].map {|film| film['id']}.compact
    cast_films = Film.where(provider_id: cast_films_id, provider: :tmdb)
    crew_films = Film.where(provider_id: crew_films_id, provider: :tmdb)
    @films ||= (cast_films + crew_films).uniq
  end

  def films_starred_in
    films_id = credits['cast'].
      select{|film| film['adult']==false}.
      map {|film| film['id']}.compact

    films = Film.where(provider_id: films_id, provider: :tmdb).to_a
    credits['cast'].map do |cast_film|
      {
        character: cast_film['character'],
        film: films.find {|film| film.provider_id == cast_film['id']}
      }
    end
  end

  def films_worked_on
    films_id = credits['crew'].
      select{|film| film['adult']==false}.
      map {|film| film['id']}.compact
      
    films = Film.where(provider_id: films_id, provider: :tmdb).to_a
    credits['crew'].map do |cast_film|
      {
        department: cast_film['department'],
        job: cast_film['job'],
        film: films.find {|film| film.provider_id == cast_film['id']}
      }
    end
  end

  def has_profile?
    profile_path
  end

  def profile(size='original')
    AppConfig.image_uri_for [size, profile_path] if has_profile?
  end

  def age
    return unless birthday
    (Time.now.to_s(:number).to_i - birthday.to_time.to_s(:number).to_i)/10e9.to_i
  end

  def self.search(query, field=:name, order=:name, by=:asc)
    order_by([order, by]).where(field => /#{query}/i)
  end

  def self.multiple_search(query)
    search(query).map {|p| p.credits['cast'].map {|f| f['id']}.uniq}
  end

end