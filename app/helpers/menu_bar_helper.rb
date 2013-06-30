module MenuBarHelper

  def recommendations_tab
    link_to recommendations_path do
      awesome('star-empty') + " recommendations (#{current_user.recommended.unwatched.count})"
    end 
  end

  def friendships_tab
    link_to friendships_path do
      awesome('globe') + " friendships (" + label_tag('friendships', current_user.friendships.received.count) + ")"
    end 
  end
end