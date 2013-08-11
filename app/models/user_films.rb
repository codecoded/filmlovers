class UserFilms

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def [](action)
    send action
  end

  def watched
    @watched ||= films_for :watched
  end

  def loved
   @loved ||= films_for :loved
  end

  def owned
   @owned ||= films_for :owned
  end

  protected

  def films_for(action)
    Film.in id: user.actions_for(action).map(&:film_id)
  end


end