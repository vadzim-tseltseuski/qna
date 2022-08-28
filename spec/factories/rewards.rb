FactoryBot.define do
  factory :reward do
    name { 'Reward name' }
    question
    answer
    image {Rack::Test::UploadedFile.new("#{Rails.root}/public/apple-touch-icon.png", "image/png")}

  end
end
