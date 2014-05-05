class FilmEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :film
  attr_accessible :watched, :loved, :owned, :facebook_id, :film_id, :user_id, :user

  # validates :action, uniqueness: {message: "This film has already been actioned!"}, presence: true
  validates_uniqueness_of :film_id, uniqueness: {message: "This film has already been actioned!"}, presence: true, :scope => [:user_id]

  set_callback :save,     :after, :destroy_if_unactioned

  def self.counts
    select("coalesce(sum(watched::int),0) as watched_count, coalesce(sum(loved::int),0) as loved_count, coalesce(sum(owned::int),0) as owned_count").first
  end

  def self.for_user(id)
    where(user_id: id).first_or_initialize
  end

  def self.counts_for_film(id)
    where(film_id: id).counts
  end


  def self.counts_for_user(id)
    where(user_id: id).counts
  end

  def self.count_for(action)
     where(action=>true).count
  end

  def self.for_film(id)
    where(film_id: id).first_or_initialize
  end 

  def self.find_by_action(action)
    where(action=>true)
  end

  def set(action)
    return if set? action
    update_attribute action.to_sym, true
    film.increment! "#{action}_counter"
  end

  def unset(action)
    return unless set? action
    update_attribute action.to_sym, false
    film.decrement! "#{action}_counter"
  end

  def incr_film_count
    film.counters.save if film.counters.new_record?
    film.counters.inc(action, 1)
  end

  def decr_film_count
    film.counters.inc(action, -1)
  end

  def set?(action)
    send(action) == true
  end


  def actioned?
    watched || loved || owned
  end


  protected
  def destroy_if_unactioned
    destroy unless actioned?
  end


end