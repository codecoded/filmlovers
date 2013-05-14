class UserMailer < ActionMailer::Base
  default from: "info@filmlovers.co.uk"

 def welcome_email(user)
    @user = user
    @url  = "http://www.filmlovers.co.uk/users/sign_in"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end

end
