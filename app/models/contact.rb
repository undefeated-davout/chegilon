class Contact < ApplicationRecord
  # --- Belongs to ---
  belongs_to :contact_category

  # --- Before save ---
  before_save :downcase_email

  # --- Default scope ---
  default_scope -> {order(created_at: :desc)}

  # --- Validates ---
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}
  validates :contact_category, presence: true
  validates :title, presence: true, length: {maximum: 255}
  validates :content, presence: true, length: {maximum: 1024}

  private
  def downcase_email
    self.email = email.downcase
  end
end
