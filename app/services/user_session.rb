class UserSession
  include ActiveModel::Observing

  attr_reader :user
  
  def initialize(user, cookies)
    @user  = user
    user.logged_in
    cookies.signed[:user_id] = { value:user.id, expires:30.days.from_now }    
  end

  def self.current_user(cookies)    
    User.find(cookies.signed[:user_id]) if cookies.signed[:user_id] 
  end

end