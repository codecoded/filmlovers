class User
  include Mongoid::Document

  exluded_names = %w(films lists users login current_user persons channels queue site auth signout admin filmlovers)
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable



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
  # field :authentication_token, :type => String
  include Mongoid::Timestamps
  include Gravtastic

  gravtastic
  
  validates :username, :email, uniqueness: {case_sensitive: false, message: "Sorry, this username is taken"}, presence: true
  validates :username, format: {with: /^[-\w\._@]+$/i,  message: "Usernames can only contain letters, numbers, or .-_@"}, length: {minimum: 3}
  validates :username, exclusion: {:in => exluded_names, message: "Sorry, this username is not available"}

  # validates_presence_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"

  field :username,              :type => String, :default => ""
  field :first_name
  field :last_name
  field :name
  # field :email
  field :gender
  field :dob, type: DateTime

  has_many :film_user_actions, validate: false, dependent: :destroy

  embeds_many :films_lists
  embeds_many :passports
  embeds_many :friends



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

  def films
    @films ||= FilmLoverLists.new("user:#{id}:films")
  end

  def films_queue
    @queue ||= FilmsQueue.new "user:#{id}:films:queued"
  end  

  def upsert_passport(passport)
    current_passport = find_passport(passport.uid, passport.provider)
    Log.info current_passport
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
  
  def to_param
    username? ? username : id.to_s
  end
end