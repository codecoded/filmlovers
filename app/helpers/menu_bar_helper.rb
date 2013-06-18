module MenuBarHelper

  def recommendations_tab(user)
    link_to recommendations_path do
      awesome('star-empty') + " recommendations (#{user.recommended.unwatched.count})"
    end 
  end
end