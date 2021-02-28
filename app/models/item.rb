class Item < ApplicationRecord
  include ItemsHelper

  # --- Belongs to ---
  belongs_to :create_user, class_name: "User"
  belongs_to :update_user, class_name: "User"

  # --- Has many ---
  has_many :comments, dependent: :destroy
  has_many :item_stocks, dependent: :destroy
  has_many :item_stocking_users, through: :item_stocks, source: :user

  # --- Default scope ---
  # default_scope -> { order(updated_at: :desc) }

  # --- Validates ---
  validates :title, presence: true, length: {maximum: 100}
  validates :tag_list_entry, presence: true, length: {maximum: 100}
  validates :tag_list_entry, length: {maximum: 100}
  validates :content, presence: true, length: {maximum: 1048575}
  validates :update_comment, length: {maximum: 100}

  # --- ActsAsTaggableOn ---
  acts_as_taggable
  include ActsAsTaggableOn::TagsHelper

  # --- PaperTrail ---
  has_paper_trail :ignore => [:updated_at]

  def active_title
    active ? title : deleted_item_title
  end

  # Update proccess that can occur conflict
  def update_with_conflict_validation(*args)
    update(*args)
  rescue ActiveRecord::StaleObjectError
    self.lock_version = lock_version_was
    errors.add :base, "この記事は、あなたが編集中に他の人に更新されました。"
    changes.except(:content, :updated_at).each do |title, values|
      errors.add title, "was #{values.first}"
    end
    false
  end
end
