class UserPresenter < BasePresenter
  extend Forwardable

  presents :user

  def_delegators :user, :username

  def counter_for(action)
    actions.where(action: action).count
  end

  def actions
    @actions ||= user.film_entries
  end

  def avatar_url
    if user.avatar and user.avatar.file
       user.avatar.url
    elsif user.passport_provider? :facebook
      user.channels[:facebook].facebook.avatar
    else
      user.gravatar_url
    end    
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

  def sent_film_recommendations
    user.films.recommended.where('recommendations.sent'=> true )
  end

  def received_film_recommmenations
    user.films.recommended.where('recommendations.sent'=> false )
  end

end