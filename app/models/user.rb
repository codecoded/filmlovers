class User
  include Mongoid::Document
  include Gravtastic

  gravtastic
  
  field :username
  field :first_name
  field :last_name
  field :name
  field :email
  field :gender
  field :dob, type: DateTime

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
    passports.where("provider" => provider.to_s).exists?
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

  def to_param
    username? ? username : id.to_s
  end
end