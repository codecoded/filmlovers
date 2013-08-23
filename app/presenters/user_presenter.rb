class UserPresenter < BasePresenter
  extend Forwardable

  presents :user

  # def_delegators :user, :name, :has_profile?, :id, :biography, :portfolio


  def avatar(size='normal')
    if user.passport_provider? :facebook
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