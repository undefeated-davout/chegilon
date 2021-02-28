FactoryBot.define do
  factory :contact_category do
    name "問い合わせ"
    active true
    output_number 1

    factory :contact_category_chegilon do
      name "Chegilonについて"
      active true
      output_number 2
    end

    factory :contact_category_withdrawal do
      name "退会したい"
      active true
      output_number 3
    end

    factory :contact_category_password do
      name "その他"
      active true
      output_number 4
    end

    factory :contact_category_sonota do
      name "その他"
      active true
      output_number 5
    end
  end
end
