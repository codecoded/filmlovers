class FilmEntry
  include Mongoid::Document
  include Mongoid::Timestamps

  # belongs_to  :film, validate: false
  # belongs_to  :user, validate: false

  field :user,      type: Hash
  field :film,      type: Hash
  field :user_id,   type: String
  field :film_id,   type: String

  embeds_many :recommendations, class_name: "FilmRecommendation"
  embeds_many :actions,         class_name: "FilmAction"

  index({ user_id: -1, film_id: 1 }, { unique: false, name: "film_entry_index", background: true })
  index({ actions: 1 }, { unique: false, name: "film_actions_index", background: true })
  index({ "actions.updated_at" => 1 }, { unique: false, name: "film_actions_updated_at_index", background: true })

  validates_presence_of   :user_id, message: 'A user id must be associated to a film entry'
  validates_presence_of   :film_id, message: 'A film id must be associated to a film entry'

  def self.fetch_for(user, film)
    find_by(user_id: user.id, film_id: film.id) || 
    create!(user_id: user.id, user: user.attributes.slice(*user_fields), film_id: film.id, film: film.attributes.slice(*film_fields))
  end

  def self.find_by_action(id)
    where("actions.action"=>id.to_sym)
  end

  def self.films
    only(:film).map {|f| Film.new f.film}
  end

  def self.[](film)
    find_by(film_id: film['_id']) || new
  end

  def self.page_and_sort(sort_by=:recent_action, page_no=1, page_size=AdminConfig.instance.page_size)
    sort_order = sort_orders[sort_by.to_s]
    order_by(sort_order).page(page_no).per(page_size)
  end

  def fetch_film
    @film ||= Film.find(film_id)
  end

  def fetch_user
    @user ||= User.find(user_id)
  end

  def do_action(action)
    !actions.find_or_create_by(action: action).new_record?
  end

  def undo_action(action)
    actions.where(action: action).destroy
  end

  def recommend_to(friendships, comment=nil)
    friendships.to_a.map do |friendship| 
      recommendation = recommendations.create(friend: friendship.friend, comment: comment) if recommend?(friendship)
      recommendation.recommend
      recommendation
    end
  end

  def new_recommendation_friends
    fetch_user.friendships.confirmed.where(:friend_id.nin => recommendations.map(&:friend_id))
  end

  def recommend?(friendship)
    friendship.confirmed? and 
    !recommended?(friendship.friend)
  end

  def actioned?(action)
    actions.actioned? action
  end

  def recommended?(friend)
    recommendations.recommended? friend
  end

  # def friend_actioned_film?(friend)
  #   friend.actioned_film(film)
  # end

  private
  def self.user_fields
    ['_id', 'username']
  end

  def self.film_fields 
    ['_id', 'title', 'poster', 'release_date', 'genres', 'release_date_country', 'trailer', 'provider', 'provider_id']
  end

  def self.sort_orders
    {
      'title'                 =>  ['film.title', :asc], 
      'recent_action'         =>  ['actions.updated_at', :desc],
      'release_date'          =>  ['film.release_date', :desc],
      'earliest_release_date' =>  ['film.release_date', :asc]
    }
  end

end