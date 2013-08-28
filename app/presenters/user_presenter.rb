class UserPresenter < BasePresenter
  extend Forwardable

  presents :user

  def_delegators :user, :username

  def counter_for(action)
    actions.where(action: action).count
  end


  def actions
    @actions ||= user.film_user_actions
  end

  def avatar(size='normal')
    if user.avatar and user.avatar.file
       image_tag user.avatar.url, :class=>"avatar #{size}", title: user.username, alt: "profile picture for #{user.username}"
    elsif user.passport_provider? :facebook
      image_tag user.channels[:facebook].facebook.avatar, :class=>"avatar #{size}", title: user.username, alt: "profile picture for #{user.username}"
    else
      image_tag user.gravatar_url, :class=>"avatar #{size}", title: user.username, alt: "profile picture for #{user.username}", size: "78x78"
    end
  end

  def cover_image
    # return unless cover = user.profile.cover_image
    image_tag "content/hero-image-ironman.jpg", size:"1600x648"
  end


  def user_recommendations
    @user_recommendations ||= user.recommendations.order_by(:created_at.desc).visible
  end

  def friends_recommmenations
    @friends_recommmenations ||= user.recommended.unwatched
  end

end