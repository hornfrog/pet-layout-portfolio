FactoryBot.define do
  sequence :title do |n|
    "レシピ#{n}"
  end

  factory :recipe do
    title
    description { Faker::Lorem.sentence }
    association :user
    association :category

    trait :with_images do
      transient do
        images_count { 3 }
      end

      after(:build) do |recipe, evaluator|
        evaluator.images_count.times do
          recipe.images.attach(
            io: File.open(Rails.root.join('spec/fixtures/test_image.png')),
            filename: 'test_image.png',
            content_type: 'image/png'
          )
        end
      end
    end

    factory :recipe_with_likes do
      transient do
        likes_count { 3 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:like, evaluator.likes_count, recipe: recipe)
      end
    end
  end
end
