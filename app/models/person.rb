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
    cast_films = credits['cast'].map {|f| Film.find(f['id']) || Film.create(f)}
    crew_films =  credits['crew'].map {|f| Film.find(f['id']) || Film.create(f)}
    @films ||= (cast_films + crew_films).uniq
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