FactoryBot.define do
  factory :comment do
    user factory: :user_tom
    item factory: :item
    content "コメント内容テスト"
    image ""
    remove_image false
    image_cache ""
  end
end
