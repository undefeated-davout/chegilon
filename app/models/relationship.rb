class Relationship < ApplicationRecord
  # --- Belongs to ---
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # --- Default scope ---
  default_scope -> {order(updated_at: :desc)}

  # --- Validates ---
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
