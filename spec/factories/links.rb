FactoryBot.define do
  factory :link do
    name { "MyLink" }
    url { "https://fbi.com" }

    trait :gist_link do
      url { 'https://gist.github.com/vadzim-tseltseuski/b6d17f70e6ae691b907d0e76e5083297' }
    end
  end
end