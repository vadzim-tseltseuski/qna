# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'QuestionTitle' }
    body { 'QuestionBody' }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      after(:create) do |question|
        create_list(:answer, 3, question_id: question.id)
      end
    end

    trait :with_files do
      files {[Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb", "text/x-ruby")]}
    end
  end
end
