# coding: utf-8

# 問い合わせカテゴリー初期登録
ContactCategory.create(name: "Chegilonに関するお問い合わせ", active: true, output_number: 1)
ContactCategory.create(name: "不適切な記事を報告する", active: true, output_number: 2)
ContactCategory.create(name: "その他", active: true, output_number: 3)

# ActiveAdminの初期ユーザー登録
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
