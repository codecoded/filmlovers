module UserListsHelper

  def user_lists
    @lists ||= viewing_own? ? user.films_lists : user.films_lists.viewable
  end
end
