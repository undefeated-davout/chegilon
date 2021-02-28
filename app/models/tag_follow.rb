class TagFollow < ApplicationRecord
  # --- Belongs to ---
  belongs_to :tag
  belongs_to :user

  # --- Default scope ---
  default_scope -> {order(updated_at: :desc)}

  # --- Validates ---
  validates :tag_id, presence: true
  validates :user_id, presence: true
end
