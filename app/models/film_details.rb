class FilmDetails
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :film, autobuild: true

  def method_missing(m, *args, &block) 
    self[m] || super
  end


  # def year
  #   return if release_date.blank?
  #   release_date.to_date.year
  # end






  # def title
  #   self['title']
  # end

  # def budget
  #   self['budget']
  # end

  # def images
  #   self[:images]
  # end


  # def trailers
  #   self[:trailers]
  # end

  # def casts
  #   self[:casts]
  # end

  # def overview
  #   self[:overview]
  # end

  # def runtime
  #   self[:runtime]
  # end

  # def has_poster?
  #   self[:poster_path]
  # end


  # def score
  #   watched = actions_for(:watched).count
  #   return 0 unless watched > 0
  #   ((actions_for(:loved).count / watched) * 100).round(0)
  # end

  # def to_param
  #   "#{title.parameterize}-#{year}"
  # end


  # def actions_for(action)
  #   film_user_actions.where(action: action)
  # end

  # def uk_release
  #   @uk_release ||= release_for 'GB'
  # end

  # def find_uk_release_date
  #   @uk_release ? uk_release['release_date'] : release_date
  # end

  # def uk_certification
  #   uk_release['certification'] if @uk_release
  # end



  # def genres
  #   self['genres']
  # end

  # def spoken_languages
  #   self['spoken_languages']
  # end

  # def not_allowed?
  #   !release_date || self['adult']
  # end

  # def production_companies
  #   self['production_companies']
  # end

  # def production_countries
  #   self['production_countries']
  # end

  # def status
  #   self['status']
  # end

  # def tagline
  #   self['tagline']
  # end
  
  # def release_for(country_code)
  #   return unless !releases['countries'].blank?
  #   releases['countries'].find {|r| r['iso_3166_1']=='GB'}
  # end


end

