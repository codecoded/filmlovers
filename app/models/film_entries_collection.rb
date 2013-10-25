class FilmEntriesCollection

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def entries
    FilmEntry.where(user_id: user.id)
  end

  def actioned
    entries.where(:actions.not => {"$size"=>0}, :actions.exists => true)
  end

  def recommended
    entries.where(:recommendations.exists => true)
  end

  def count
    @count ||= entries.count
  end

  def find(film)
    entries[film]
  end

  def in(film_ids)
    entries.in(film_id: film_ids)
  end

  def select(film_ids)
    actioned.in(film_id: film_ids)
  end

  def find_or_create(film)
    entries.fetch_for(user, film)
  end

  def [](action_id)
    find_by_action(action_id.to_sym)
  end

  def actioned?(film)
    !find(film).actions.blank?
  end

  def find_by_action(id)
    entries.find_by_action(id)
  end


  def method_missing(meth, *args, &block)
    %Q[owned watched loved].include?(meth.to_s) ? self[meth] : super
  end
end