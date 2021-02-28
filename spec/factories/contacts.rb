FactoryBot.define do
  factory :contact do
    email "michael.chegilon.info@gmail.com"
    association :contact_category, factory: :contact_category_sonota
    title "テストタイトル"
    content "テスト本文"

    factory :contact_password do
      email "michael.chegilon.info@gmail.com"
      association :contact_category, factory: :contact_category_password
      title "テストタイトル"
      content "テスト本文"
    end
  end
end
