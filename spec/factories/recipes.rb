FactoryBot.define do
  factory :recipe do
    title { 'ジャングルレイアウト' }
    description { 'アマゾンのようなレイアウトです。' }
    user
    category
  end
end
