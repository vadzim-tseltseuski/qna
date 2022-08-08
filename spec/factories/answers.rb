# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer_Body_#{n}"
    end
  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
