class FilmEntryObserver < ActiveRecord::Observer
  observe :film_entry

  def after_update(film_entry)
    Log.debug 'film entry created'
    # return unless film_user_action.action == :loved
    # Log.debug "Created film_user_action: #{film_user_action}"
    # comparer = ComparisonService.new film_user_action.user
    # Thread.new do
    #   comparer.friends_sorted_by_rating(40).each do |rated_friend|
    #     recommendation = film_user_action.user.recommendations.create friend: rated_friend[:friend], recommendable: film_user_action.film, auto: true
    #   end
    # end
  end

  def after_destroy(film_action)
    Log.debug 'film action deleted'
  end
  
  def publish_story
    # fb_action = case user_action
    #           when :loved; "#{Facebook::namespace}:love"
    #           when :watched;  "video.watches"
    #           else; nil
    #         end
    # return unless fb_action and facebook_passport
    # Thread.new do
    #   fb_id = Facebook::UserAPI.new(facebook_passport).publish_story(fb_action, :movie, film_url(film))
    #   @film_user_action.update_attributes!(facebook_id:fb_id)
    #   Log.info "#{film.title} published to facebook as #{user_action} by #{current_user.name}"
    # end
  end

  def facebook_passport
    # current_user.passport_for(:facebook)
  end

  def delete_story
  end

end