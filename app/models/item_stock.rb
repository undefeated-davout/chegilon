class ItemStock < ApplicationRecord
  # --- Belongs to ---
  belongs_to :item
  belongs_to :user

  # --- Default scope ---
  default_scope -> {order(updated_at: :desc)}

  # --- Validates ---
  validates :item_id, presence: true
  validates :user_id, presence: true
end
