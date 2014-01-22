class FilmRecommendation < ActiveRecord::Base
  belongs_to :user
  belongs_to :film
  belongs_to :friend, class_name: 'User'

  attr_accessible :auto, :comment, :film_id, :sent, :state, :friend_id
  
  # validates_uniqueness_of :friend_id, uniqueness: {message: "This film has already been recommended to this friend!"}, presence: true, :scope => [:film_id]

  # index({ friend: 1, state: 1},   { unique: true, name: "recommendation_index", background: true })

  scope :recommended,  -> {where state: :recommended}
  scope :sent,      -> {where(sent: true)}
  scope :received,  -> {where state: :received}
  scope :approved,  -> {where state: :approved}

  state_machine :initial => :recommended do
    event(:unrecommend)  { transition :recommended                => :removed     }  
    event(:approve)      { transition [:recommended, :hidden]     => :approved    }
    event(:hide)         { transition :recommended                => :hidden      }
    event(:show)         { transition :hidden                     => :recommended    }
  end

  def self.for_user(id)
    where(user_id: id)
  end 

  def self.for_friend(id)
    where(friend_id: id)
  end 

  def self.for_film(id)
    where(film_id: id)
  end 

  def self.view_by_film
    includes(:film).select(:film_id).group(:film_id)
  end

  def self.view_by_friends
    includes(:friend).select(:friend_id).group(:friend_id)
  end

  def self.recommended?(friend)
    where(friend: friend).exists?
  end


  def self.recent(limit=5)
    order('created_at desc').limit(limit)
  end


end
