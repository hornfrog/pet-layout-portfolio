FactoryBot.define do
  factory :category do
    name { "爬虫類" }
    parent_id { nil }

    trait :with_children do
      after(:create) do |category|
        create(:category, name: "トカゲ", parent_id: category.id)
      end
    end
  end
end
