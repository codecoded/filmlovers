class UserPresenter < BasePresenter
  extend Forwardable

  presents :user

  def_delegators :user, :username

  def counts
    @counts ||= user.film_entries.counts
  end

  def counter_for(action)
    counts.send "#{action}_count"
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

  def current_friendship
    return nil unless current_user
    @current_friendship ||= current_user.friendship_with user
  end


  def film_entries
    options = paging_options.merge sort_by: :recent
    @film_entries ||= ActiveUserQuery.new(user.film_entries.includes(:film), options).results
  end

  # def films_entries_presenter
  #   @films_entries_presenter ||= FilmEntriesPresenter.new(user, film_entries)
  # end

end