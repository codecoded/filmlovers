class User < ActiveRecord::Base
  attr_accessible :authentication_token, :current_sign_in_ip, :current_sign_in_at, :dob, :email, 
                  :encrypted_password, :first_name, :gender, :last_name, :last_sign_in_at, 
                  :last_sign_in_ip, :name, :remember_created_at, :reset_password_sent_at, 
                  :reset_password_token, :sign_in_count, :username, :password, :password_confirmation, :remember_me
                  
  include Gravtastic
  extend UserScopes

  gravtastic
  mount_uploader :avatar, AvatarUploader  

  exluded_names = %w(films lists users login current_user persons channels queue site auth signout admin filmlovers friendships friends recommendations recommend)
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable#, :validatable

  default_scope order(:created_at)
  
  validates_presence_of   :username, message: 'Please enter a username'
  validates_presence_of   :email, message: 'Please enter an email'
  validates_presence_of   :password, message: 'Please enter a password', on: :create
  validates :username, uniqueness: {case_sensitive: false, message: "This username is already taken, please choose another!"}
  validates :username, format: {with: /^[-\w\._@]+$/i,  message: "Usernames can only contain letters, numbers, or .-_@"}
  validates_length_of :username, :within => 3..20, :too_long => "Username is a maximum of 20 characters", :too_short => "Username is a minimum of 3 characters"
  validates :username, exclusion: {:in => exluded_names, message: "Sorry, this username is not available"}
  validates :email, uniqueness: {case_sensitive: false, message: "This email has already been registered!"}, presence: true
  validates_format_of :email, :with  => Devise.email_regexp, message: "Sorry, this doesn't seem to be a valid email"
  validates_length_of :password, :within => Devise.password_length, too_short: 'Password must be a minimun of 8 characters', too_long: 'Password must be a maximum of 128 characters', on: :create, allow_blank: true

  before_save :ensure_authentication_token

  has_many :facebook_events
  has_many :film_entries
  has_many :film_recommendations
  has_many :recommended_films, class_name: 'FilmRecommendation', foreign_key: :friend_id
  has_many :films_lists
  has_many :passports
  has_one  :profile, class_name: 'UserProfile'
  has_many :friendships
  has_many :mobile_devices

  # embedded_in :film_entry

  attr_accessible :passports
  accepts_nested_attributes_for :profile, :allow_destroy => true
  accepts_nested_attributes_for :passports

  set_callback :create,   :after, :create_profile 

  def self.from_omniauth(auth)
    passport = Passport.from_omniauth(auth)
    user = find_by_passport passport 
    user.update_from_omniauth(auth) if user.new_record?
    user
  end

  def self.find_by_passport(passport)
    found_passport = Passport.where(uid: passport.uid, provider: passport.provider).first
    found_passport ? found_passport.user : new(passports:[passport])
  end

  def create_profile
    profile = UserProfile.new
    save!
  end

  def self.from_facebook_token(access_token)
    fb_user = Facebook::UserAPI.user_from_token access_token
    passport = Passport.new({
        provider: :facebook,
        oauth_token: access_token,
        uid: fb_user["id"],
      })
    user = find_by_passport passport  

    if user.new_record?
      user.update_from_facebook_graph(fb_user) 
      user.channels[:facebook].create_friends_in_app if user.channels[:facebook]
    end
    
    user 
  end

  def self.fetch(id)
    id.is_a?(Integer) ? User.find(id) : User.find_by_username(id)
  end

 
  def upsert_passport(passport)
    current_passport = find_passport(passport.uid, passport.provider)
    current_passport ? current_passport.update_from_passport(passport) : (passports << passport) 
  end

  def update_from_omniauth(auth)
   update_attributes(
    {
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      name: auth.info.name,
      email: auth.info.email,
      gender: auth.extra.raw_info.gender
    })   

    update_username(auth.info.nickname) unless username?
  end

  def update_from_facebook_graph(fb_user)
   update_attributes(
    {
      first_name: fb_user['first_name'],
      last_name: fb_user['last_name'],
      name: fb_user['name'],
      email: fb_user['email'],
      gender: fb_user['gender']
    })   

    update_username(fb_user['username']) unless username?
  end

  def passport_provider?(provider)
    passport_for(provider)
  end

  def passport_for(provider)
    passports.find_by_provider provider.to_s
  end

  def update_username(username)
    update_attribute :username, username
  end

  def find_passport(uid, provider)
     passports.where(uid: uid, provider: provider).first
  end

  def username?
     !username.blank? 
  end

  def friendship_with(user)
    friendships.find_by_friend_id user.id
  end

  def channels
    @channels ||= UserChannels.new self
  end

  def compare_to(user)
    UserComparison.new(self, user)
  end

  # def facebook
  #   return unless @facebook ||= passport_for(:facebook)
  #   Facebook::UserAPI.new @facebook
  # end

  def notifier
    @notifier ||= UserNotifier.new(self)
  end

  # def films
  #   @film ||= FilmEntriesCollection.new self
  # end
  
  def mobile_device_by(name)
    mobile_devices.where(provider: name).first_or_initialize
  end

  def notify(notification)
    notifier.message notification
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def to_param
    username? ? username : id.to_s
  end

  def film_entry_for(film_id)
    film_entries.for_film film_id
  end

  def film_recommendation_for(film_id)
    film_recommendations.for_film film_id
  end

  def film_recommender(film)
    FilmRecommendationService.new self, film
  end
  
  private
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end