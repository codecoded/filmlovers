class User
  include Mongoid::Document

  field :username
  field :name
  field :email
  field :gender
  field :oauth_token
  field :oauth_expires_at, type: DateTime

  has_many :film_lists

  def films
    @films ||= FilmLoverLists.new("user:#{id}:films")
  end

  def films_queue
    @queue ||= FilmsQueue.new "user:#{id}:films:queued"
  end  

  def self.from_omniauth(auth)
    User.find_or_initialize_by(auth.slice(:provider, :uid)).tap do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.gender = auth.extra.raw_info.gender
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
      user.save!
    end    
  end

end