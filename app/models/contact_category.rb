class ContactCategory < ApplicationRecord
  # --- Has many ---
  has_many :contacts, dependent: :destroy

  # --- Default scope ---
  default_scope -> {order(:output_number)}

  # --- Validates ---
  validates :output_number, presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10},
            uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 50}
end
