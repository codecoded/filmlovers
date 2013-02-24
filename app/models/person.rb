class Person
  include Mongoid::Document

  field :_id, type: String, default: ->{ id }

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

  def has_profile?
    profile_path
  end

  def profile(size='original')
    AppConfig.image_uri_for [size, profile_path] if has_profile?
  end


end