class Comment < ApplicationRecord
  # --- Belongs to ---
  belongs_to :user
  belongs_to :item

  # --- Has many ---
  has_many :comment_likes, dependent: :destroy
  has_many :comment_liking_users, through: :comment_likes, source: :user

  # --- Default scope ---
  default_scope -> {order(created_at: :desc)}

  # --- Validates ---
  validates :user_id, presence: true
  validates :item_id, presence: true
  validates :content, presence: true, length: {maximum: 255}

  private
end
