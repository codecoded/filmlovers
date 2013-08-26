class FilmDetails
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :film, autobuild: true

  def method_missing(m, *args, &block) 
    self[m] || super
  end


end

