class UserFilms

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def watched
    @watched ||= user.actions_for(:watched)
  end

  def loved
   @loved ||= user.actions_for(:loved)
  end

  def owned
   @owned ||= user.actions_for(:owned)
  end



end