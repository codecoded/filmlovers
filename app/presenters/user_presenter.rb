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
    image_tag "content/hero-image-pacific-rim.jpg", size:"1280x720"
   end

end