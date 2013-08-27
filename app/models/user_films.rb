class UserFilms

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def [](action)
    send action
  end

  def all
    find
  end

  def watched
    @watched ||= where :watched
  end

  def loved
   @loved ||= find :loved
  end

  def owned
   @owned ||= find :owned
  end

  protected

  def find(action=nil)
    actions = action ? user.actions_for(action) : user.film_user_actions
    Film.without(:details, :providers).in id: actions.map(&:film_id)
  end


end