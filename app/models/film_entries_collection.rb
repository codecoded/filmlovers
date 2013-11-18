class FilmEntriesCollection

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def entries
    FilmEntry.where(user_id: user.id)
  end

  def actioned
    entries.actioned
  end

  def recommended
    entries.recommended
  end

  def received_recommendations
    recommended.where('recommendations.state'=>:received)
  end

  def sent_recommendations
    recommended.where('recommendations.state'=>'recommended')
  end

  def all_received_recommendations
    recommended.in('recommendations.state'=>[:received, :hidden, :approved] )
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

  def select_recommendation(id)
    object_id =  Moped::BSON::ObjectId(id)
    entries.where('recommendations._id'=>object_id).first.recommendations.find  object_id
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