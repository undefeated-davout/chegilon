class User < ApplicationRecord
  include UsersHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  # --- Before save ---
  before_save :downcase_email

  # --- Has many ---
  # --- Items ---
  has_many :create_items, class_name: "Item",
           foreign_key: "create_user_id"
  has_many :update_items, class_name: "Item",
           foreign_key: "update_user_id"
  # --- Comments ---
  has_many :comments
  # --- Relationships ---
  has_many :active_relationships, class_name: "Relationship",
           foreign_key: "follower_id",
           dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # --- Item stocks ---
  has_many :item_stocks, dependent: :destroy
  has_many :item_stocking_items, through: :item_stocks, source: :item
  # --- Comment likes ---
  has_many :comment_likes, dependent: :destroy
  has_many :comment_liking_comments, through: :comment_likes, source: :comment
  # --- Tag follows ---
  has_many :tag_follows, dependent: :destroy
  has_many :tag_following_tags, through: :tag_follows, source: :tag

  # --- Default scope ---
  default_scope -> {order(updated_at: :desc)}

  # --- Validates ---
  validates :name, presence: true, length: {maximum: 20}, uniqueness: {case_sensitive: false},
            format: {with: /\A[a-z0-9]+\z/i,
                     message: "英文字のみが使用できます"}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :site_url, length: {maximum: 2000},
            format: {with: URI::regexp(%w(http https))},
            allow_blank: true
  validates :area, length: {maximum: 255},
            format: {with: /\A[,a-z0-9]+\z/i,
                     message: "英数文字、カンマのみが使用できます"},
            allow_blank: true
  validates :self_introduction, length: {maximum: 255}


  def to_param
    name ? name : id.to_s
  end

  def self.find_by_name_or_id(arg)
    find_by_name(arg) || find(arg)
  end

  def self.find(arg)
    find_by_name(arg) || super
  end

  def active_name
    active ? name : exit_user_name
  end

  def active_following
    following.where(active: true)
  end

  def active_followers
    followers.where(active: true)
  end

  def active_item_stocking_items
    item_stocking_items.where(active: true)
  end

  def active_create_items
    create_items.where(active: true)
  end


  # --- Feeds ---
  # Feed items: following user's, following tag's, stocking item's activities.
  def feed_items
    # Following users
    following_user_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    # Following Tags
    following_tag_ids = "SELECT tag_id FROM tag_follows
                        WHERE  user_id = :user_id"
    # Following tag's items
    following_tag_item_ids = "SELECT taggable_id FROM taggings WHERE taggable_type = 'Item' AND tag_id IN (#{following_tag_ids})"
    # Stocking items
    stocking_item_ids = "SELECT item_id FROM item_stocks WHERE user_id = :user_id"

    Item.includes(:update_user).where("create_user_id IN (#{following_user_ids}) OR update_user_id IN (#{following_user_ids})
                OR create_user_id = :user_id OR update_user_id = :user_id
                OR id IN (#{stocking_item_ids})
                OR id IN (#{following_tag_item_ids})", user_id: id)
        .where(active: true).limit(20)
  end

  # Feed comments: following user's, following tag's item's, stocking item's comments.
  def feed_comments
    # Following users
    following_user_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    # Following Tags
    following_tag_ids = "SELECT tag_id FROM tag_follows
                        WHERE  user_id = :user_id"
    # Following tag's items
    following_tag_item_ids = "SELECT taggable_id FROM taggings WHERE taggable_type = 'Item' AND tag_id IN (#{following_tag_ids})"
    # Create or Update items
    create_update_item_ids = "SELECT id FROM items WHERE create_user_id = :user_id OR update_user_id = :user_id"
    # Stocking items
    stocking_item_ids = "SELECT item_id FROM item_stocks WHERE user_id = :user_id"
    # Liking comments
    liking_comment_ids = "SELECT comment_id FROM comment_likes WHERE user_id = :user_id"
    # Liking comment's items
    liking_comment_item_ids = "SELECT item_id FROM comments WHERE id IN (#{liking_comment_ids})"
    # Commenting items
    comment_item_ids = "SELECT item_id FROM comments WHERE user_id = :user_id"

    Comment.includes([:user, :item]).where("user_id IN (#{following_user_ids})
                  OR user_id = :user_id
                  OR item_id IN (#{create_update_item_ids})
                  OR item_id IN (#{stocking_item_ids})
                  OR item_id IN (#{following_tag_item_ids})
                  OR item_id IN (#{liking_comment_item_ids})
                  OR item_id IN (#{comment_item_ids})", user_id: id).limit(13)
  end


  # --- Populars ---
  def popular_items
    get_popular_items()
  end

  def popular_items_on_user
    get_popular_items(id)
  end

  def popular_comments
    get_popular_comments()
  end

  def popular_comments_on_user
    get_popular_comments(id)
  end

  def popular_users
    user_join = User.arel_table
    relationship_join = Relationship.arel_table
    join_condition = user_join.join(relationship_join, Arel::Nodes::OuterJoin)
                         .on(user_join[:id].eq(relationship_join[:followed_id])).join_sources
    user_id_and_counts = User.limit(10).joins(join_condition).group(:id)
                             .select(user_join[:id], user_join[:id].count.as('cnt'))
                             .where(relationship_join[:created_at].gteq 7.days.ago)
                             .where(user_join[:active].eq true)
                             .reorder('cnt DESC').order(:id)
    user_id_array = []
    user_id_and_counts.each do |user_id_and_count|
      user_id_array.push(user_id_and_count.id)
    end
    user_hash = Hash[User.where(id: user_id_array).map {|user| [user.id, user]}]
    user_list = []
    user_id_and_counts.each do |user_id_and_count|
      user_list.push(user_hash[user_id_and_count.id])
    end
    user_list
  end

  def popular_tags
    tag_join = Tag.arel_table
    tag_follow_join = TagFollow.arel_table
    join_condition = tag_join.join(tag_follow_join, Arel::Nodes::OuterJoin)
                         .on(tag_join[:id].eq(tag_follow_join[:tag_id])).join_sources
    tag_id_and_counts = Tag.limit(10).joins(join_condition).group(:id)
                            .select(tag_join[:id], tag_join[:id].count.as('cnt'))
                            .where(tag_follow_join[:created_at].gteq 7.days.ago)
                            .reorder('cnt DESC').order(:id)
    tag_id_array = []
    tag_id_and_counts.each do |tag_id_and_count|
      tag_id_array.push(tag_id_and_count.id)
    end
    tag_hash = Hash[Tag.where(id: tag_id_array).map {|tag| [tag.id, tag]}]
    tag_list = []
    tag_id_and_counts.each do |tag_id_and_count|
      tag_list.push(tag_hash[tag_id_and_count.id])
    end
    tag_list
  end


  # --- contributions ---
  # Stocked items
  def stocked_items
    # Creating items
    item_ids = "SELECT id FROM items WHERE create_user_id = :user_id"
    # Except for self stock
    item_stock_item_ids = "SELECT item_id FROM item_stocks WHERE item_id IN (#{item_ids}) AND user_id <> :user_id"
    Item.where("id IN (#{item_stock_item_ids})", user_id: id).where(active: true)
  end

  # Liked comments
  def liked_comments
    # Creating comments
    comment_ids = "SELECT id FROM comments WHERE user_id = :user_id"
    # Except for self stock
    comment_like_comment_ids = "SELECT comment_id FROM comment_likes WHERE comment_id IN (#{comment_ids}) AND user_id <> :user_id"
    Comment.where("id IN (#{comment_like_comment_ids})", user_id: id)
  end


  # --- User follows ---
  # Follow user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollow user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Checking following user or not.
  def following?(other_user)
    following.include?(other_user)
  end


  # --- Tag follows ---
  # Follow tag
  def tag_follow(tag)
    tag_follows.create(tag_id: tag.id)
  end

  # Unfollow tag
  def tag_unfollow(tag)
    tag_follows.find_by(tag_id: tag.id).destroy
  end

  # Checking following tag or not.
  def tag_following?(tag)
    tag_follows.exists?(tag_id: tag.id)
  end


  # --- Item stocks ---
  # Stock item
  def item_stock(item)
    item_stocks.create(item_id: item.id)
  end

  # Unstock item
  def item_unstock(item)
    item_stocks.find_by(item_id: item.id).destroy
  end

  # Checking stocking item or not.
  def item_stocking?(item)
    item_stocking_items.include?(item)
  end

  # Creating item's stock count
  def stocked_items_count
    # Creating items
    item_ids = "SELECT id FROM items WHERE create_user_id = :user_id AND active = 'true'"
    # Except for self stock
    ItemStock.where("item_id IN (#{item_ids}) AND user_id <> :user_id", user_id: id).count
  end


  # --- Comment likes ---
  # Like comment
  def comment_like(comment)
    comment_likes.create(comment_id: comment.id)
  end

  # Unlike comment
  def comment_unlike(comment)
    comment_likes.find_by(comment_id: comment.id).destroy
  end

  # Checking liking comment or not.
  def comment_liking?(comment)
    comment_liking_comments.include?(comment)
  end

  # Creating comment's like count
  def liked_comments_count
    # Creating comments
    comment_ids = "SELECT id FROM comments WHERE user_id = :user_id"
    # Except for self like
    CommentLike.where("comment_id IN (#{comment_ids}) AND user_id <> :user_id", user_id: id).count
  end

  def leave
    #leave_atに退会時刻を追記
    update_attribute(:leave_at, Time.current)
    update_attribute(:active, false)

    # また、userのメールアドレスの頭にleave_atを追加する。
    # メールアドレスを変更すると原則確認メールが送信されるため、
    # 送信をスキップすることを宣言した上でupdateする。
    new_email = self.leave_at.to_i.to_s + '_' + self.email.to_s
    self.skip_reconfirmation!
    update_attribute(:email, new_email)
  end


  private

  def downcase_email
    self.email = email.downcase
  end

  # --- Populars ---
  def get_popular_items(user_id = nil)
    item_join = Item.arel_table
    item_stock_join = ItemStock.arel_table
    join_condition = item_join.join(item_stock_join, Arel::Nodes::OuterJoin)
                         .on(item_join[:id].eq(item_stock_join[:item_id])).join_sources
    if user_id
      item_id_and_counts = Item.limit(10).joins(join_condition).group(:id)
                               .select(item_join[:id], item_stock_join[:id].count.as('cnt'))
                               .where(item_join[:create_user_id].eq user_id)
                               .where(item_stock_join[:id].not_eq(nil))
                               .where(item_join[:active].eq true)
                               .reorder('cnt DESC').order(id: :desc)
    else
      item_id_and_counts = Item.limit(10).joins(join_condition).group(:id)
                               .select(item_join[:id], item_stock_join[:id].count.as('cnt'))
                               .where(item_stock_join[:created_at].gteq 7.days.ago)
                               .where(item_join[:active].eq true)
                               .reorder('cnt DESC').order(id: :desc)
    end
    item_id_array = []
    item_id_and_counts.each do |item_id_and_count|
      item_id_array.push(item_id_and_count.id)
    end
    item_hash = Hash[Item.includes(:update_user).where(id: item_id_array).map {|item| [item.id, item]}]
    item_list = []
    item_id_and_counts.each do |item_id_and_count|
      item_list.push(item_hash[item_id_and_count.id])
    end
    item_list
  end

  def get_popular_comments(user_id = nil)
    comment_join = Comment.arel_table
    comment_like_join = CommentLike.arel_table
    join_condition = comment_join.join(comment_like_join, Arel::Nodes::OuterJoin)
                         .on(comment_join[:id].eq(comment_like_join[:comment_id])).join_sources
    if user_id
      comment_id_and_counts = Comment.limit(10).joins(join_condition).group(:id)
                                  .select(comment_join[:id], comment_like_join[:id].count.as('cnt'))
                                  .where(comment_join[:user_id].eq user_id)
                                  .where(comment_like_join[:id].not_eq(nil))
                                  .reorder('cnt DESC').order(id: :desc)
    else
      comment_id_and_counts = Comment.limit(10).joins(join_condition).group(:id)
                                  .select(comment_join[:id], comment_like_join[:id].count.as('cnt'))
                                  .where(comment_like_join[:created_at].gteq 7.days.ago)
                                  .reorder('cnt DESC').order(id: :desc)
    end
    comment_id_array = []
    comment_id_and_counts.each do |comment_id_and_count|
      comment_id_array.push(comment_id_and_count.id)
    end
    comment_hash = Hash[Comment.includes([:item, :user]).where(id: comment_id_array).map {|comment| [comment.id, comment]}]
    comment_list = []
    comment_id_and_counts.each do |comment_id_and_count|
      comment_list.push(comment_hash[comment_id_and_count.id])
    end
    comment_list
  end
end
