FactoryBot.define do
  factory :item do
    title "サンプルタイトル"
    tag_list_entry "サンプルタグ"
    content "サンプル本文"
    update_comment nil
    create_user factory: :user_michael
    update_user factory: :user_jackson

    factory :item_test do
      title "testタイトル"
      tag_list_entry "testタグ"
      content "test本文"
      update_comment nil
      create_user factory: :user_tom
      update_user factory: :user_vageena
    end

    factory :item_job do
      title "jobタイトル"
      tag_list_entry "jobタグ"
      content "job本文"
      update_comment nil
      create_user factory: :user_maxwell
      update_user factory: :user_ridey
    end
  end
end
