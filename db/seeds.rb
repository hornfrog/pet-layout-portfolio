# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 親カテゴリ
reptiles      = Category.find_or_create_by(name: "爬虫類", parent: nil)
amphibians    = Category.find_or_create_by(name: "両生類", parent: nil)
fish          = Category.find_or_create_by(name: "熱帯魚", parent: nil)
small_animals = Category.find_or_create_by(name: "小動物", parent: nil)

# 子カテゴリ
{
  reptiles => ["トカゲ", "ヤモリ", "ヘビ", "カメ", "その他"],
  amphibians => ["カエル", "イモリ・サンショウウオ", "その他"],
  fish => ["熱帯魚水槽", "水草水槽", "その他"],
  small_animals => ["ハムスター", "その他"]
}.each do |parent, children|
  children.each do |child_name|
    Category.find_or_create_by(name: child_name, parent: parent)
  end
end

# 孫カテゴリ
{
  "トカゲ" => ["地上棲", "樹上棲"],
  "ヤモリ" => ["地上棲", "樹上棲"],
  "カエル" => ["地上棲", "樹上棲"]
}.each do |parent_name, grandchildren|
  parent = Category.find_by(name: parent_name)
  next unless parent  

  grandchildren.each do |grandchild_name|
    Category.find_or_create_by(name: grandchild_name, parent: parent)
  end
end
