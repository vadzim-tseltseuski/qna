FactoryBot.define do
  sequence :email do |n|
    "user#{n}@qna.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.zone.now }
  end
end
