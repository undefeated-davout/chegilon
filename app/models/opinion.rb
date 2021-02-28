class Opinion < ApplicationRecord
  # --- Default scope ---
  default_scope -> {order(created_at: :desc)}

  # --- Validates ---
  validates :content, presence: true, length: {maximum: 1024}
end
