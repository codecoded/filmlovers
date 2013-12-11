class FilmEntriesCollection

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def [](film)
    FilmEntry.new user, film
  end

  def actioned
    user.film_actions.pluck(:film_id).uniq
  end

  def grouped
    user.film_entries.select(:film_id).group(:film_id)
  end

  def recommended
    user.films_recommended
  end

  def received_recommendations
    recommended.received
  end

  def sent_recommendations
    recommended.recommended
  end

  def all_received_recommendations
    recommended.where(state:[:received, :hidden, :approved])
  end

  def count
    @count ||= actioned.count
  end

  def find(film)
    entries[film]
  end

  def in(film_ids)
    user.film_actions.where(film_id: film_ids).pluck(:film_id).distinct
  end

  def select(film_ids)
    self.in(film_ids)
  end

  def select_recommendation(id)
    FilmRecommendation.find id
  end 

  def find_or_create(film)
    self[film]
  end

  # def actioned?(film)
  #   !find(film).actions.blank?
  # end

  def find_by_action(id)
    user.film_actions.where(action: id)
  end

  def method_missing(meth, *args, &block)
    %Q[owned watched loved].include?(meth.to_s) ? self[meth] : super
  end
end