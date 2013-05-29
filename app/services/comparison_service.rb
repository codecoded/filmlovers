class ComparisonService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def friends_sorted_by_rating(threshold=0)
    rated_friends = []

    user.friends.map(&:friend).each do |friend|
      score = user.compare_to(friend).overall
      rated_friends << {friend: friend, score: score} if score >= threshold
    end

    rated_friends.sort_by {|rated_friend| rated_friend[:score]}
  end

end