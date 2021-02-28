class Tag < ApplicationRecord
  # --- Has many ---
  has_many :tag_follows, dependent: :destroy
  has_many :tag_following_users, through: :tag_follows, source: :user
  has_many :taggings

  def tag_following_active_users
    tag_following_users.where(active: true)
  end
end
