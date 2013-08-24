class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  
  exluded_names = %w(films lists users login current_user persons channels queue site auth signout admin filmlovers friendships friends recommendations recommend)
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :token_authenticatable#, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  index({ username: 1}, { unique: true, name: "user_username_index", background: true })

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  field :authentication_token, :type => String


  gravtastic
  
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
  # validates_presence_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"

  field :username,              :type => String, :default => ""
  field :first_name
  field :last_name
  field :name
  # field :email
  # field :email
  field :gender
  field :dob, type: DateTime

  has_many :film_user_actions, validate: false, dependent: :destroy
  has_many :recommendations
  has_many :facebook_events


  attr_accessible :avatar, :username, :email, :first_name, :last_name, :password, :confirm_password
  mount_uploader :avatar, AvatarUploader  

  embeds_one  :profile, class_name: 'UserProfile', autobuild: true
  embeds_many :films_lists
  embeds_many :passports
  embeds_many :friendships
  accepts_nested_attributes_for :profile, :allow_destroy => true

  def self.from_omniauth(auth)
    passport = Passport.from_omniauth(auth)
    user = find_by_passport passport 
    user.update_from_omniauth(auth) if user.new_record?
    user
  end

  def self.find_by_passport(passport)
    user = User.where("passports.uid" => passport.uid, "passports.provider" => passport.provider).first
    user ? user : User.new(passports:[passport])
  end

  def films_queue
    @queue ||= FilmsQueue.new "user:#{id}:films:queued"
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

  def passport_provider?(provider)
    passport_for(provider)
  end

  def passport_for(provider)
    passports.find_by(provider: provider.to_s)
  end

  def update_username(username)
    update_attribute :username, username
  end

  def find_passport(uid, provider)
     passports.find_by(uid: uid, provider: provider)
  end

  def username?
     !username.blank? 
  end

  def actions_for(action)
    film_user_actions.where(action: action)
  end

  def film_actioned?(film, action)
    film_user_actions.where(film: film, action: action).exists?
  end

  def friendship_with(user)
    friendships.find_by(friend_id: user.id)
  end

  def channels
    @channels ||= UserChannels.new self
  end

  def compare_to(user)
    UserComparison.new(self, user)
  end

  def facebook
    return unless @facebook ||= passport_for(:facebook)
    Facebook::UserAPI.new @facebook
  end

  def recommended
    @recommended ||= UserRecommendations.new self
  end
  
  def notifier
    @notifier ||= UserNotifier.new(self)
  end

  def films
    @film ||= UserFilms.new self
  end
  # def logged_in
  #   sign_in_count = sign_in_count ? sign_in_count+=1 : 1
  #    last_sign_in_at = current_sign_in_at
  #   current_sign_in_at = Time.now.utc
   
  #   save
  # end

  def notify(notification)
    notifier.message notification
  end

  def to_param
    username? ? username : id.to_s
  end
end