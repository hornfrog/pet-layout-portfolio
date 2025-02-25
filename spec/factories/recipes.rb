FactoryBot.define do
  factory :recipe do
    title { "MyString" }
    description { "MyText" }
    user { nil }
    category { nil }
  end
end
