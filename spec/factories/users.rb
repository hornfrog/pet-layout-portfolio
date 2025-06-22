FactoryBot.define do
  factory :user do
    name { 'エキゾチック好き太郎' }
    email { Faker::Internet.email }
    password { 'password' }
  end
end
