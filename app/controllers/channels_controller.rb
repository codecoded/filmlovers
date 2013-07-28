class ChannelsController < ApplicationController

  def facebook
    current_user.channels[:facebook].app_friends
  end

  def netflix
  end
end
