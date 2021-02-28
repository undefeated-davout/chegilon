FactoryBot.define do
  factory :user do
    name "sampleuser"
    email "sampleuser.chegilon.info@gmail.com"
    password "samplepass"
    confirmed_at Time.now

    factory :admin do
      name "sampleadminuser"
      email "sampleadminuser.chegilon.info@gmail.com"
      password "samplepass"
      admin true
      confirmed_at Time.now
    end

    factory :user_michael do
      name "michael"
      email "michael.chegilon.info@gmail.com"
      password "samplepass"
      confirmed_at Time.now
    end

    factory :user_jackson do
      name "jackson"
      email "jackson.chegilon.info@gmail.com"
      password "samplepass"
      confirmed_at Time.now
    end

    factory :user_tom do
      name "tom"
      email "tom.chegilon.info@gmail.com"
      password "samplepass"
      confirmed_at Time.now
    end

    factory :user_vageena do
      name "vageena"
      email "vageena.chegilon.info@gmail.com"
      password "samplepass"
      confirmed_at Time.now
    end

    factory :user_maxwell do
      name "maxwell"
      email "maxwell.chegilon.info@gmail.com"
      password "samplepass"
      confirmed_at Time.now
    end

    factory :user_ridey do
      name "ridey"
      email "ridey.chegilon.info@gmail.com"
      password "samplepass"
      confirmed_at Time.now
    end
  end
end
