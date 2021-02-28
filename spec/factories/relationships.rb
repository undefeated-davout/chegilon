FactoryBot.define do
  factory :relationship do
    follower factory: :user_vageena
    followed factory: :user_maxwell
  end
end
