require "open-uri"

puts "== データ初期化 =="
Favorite.destroy_all
Like.destroy_all
Recipe.destroy_all
Category.destroy_all
User.where(email: "test@example.com").destroy_all

puts "== テストユーザー作成 =="
test_user = User.create!(
  name: "テスト",
  email: "test@example.com",
  password: "password123"
)

puts "== カテゴリ作成 =="

# 親カテゴリ
reptiles      = Category.find_or_create_by!(name: "爬虫類", parent: nil)
amphibians    = Category.find_or_create_by!(name: "両生類", parent: nil)
fish          = Category.find_or_create_by!(name: "熱帯魚", parent: nil)
small_animals = Category.find_or_create_by!(name: "小動物", parent: nil)

# 子カテゴリ
{
  reptiles => ["トカゲ", "ヤモリ", "ヘビ", "カメ", "その他"],
  amphibians => ["カエル", "イモリ・サンショウウオ", "その他"],
  fish => ["熱帯魚水槽", "水草水槽", "その他"],
  small_animals => ["ハムスター", "その他"]
}.each do |parent, children|
  children.each do |child_name|
    Category.find_or_create_by!(name: child_name, parent: parent)
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
    Category.find_or_create_by!(name: grandchild_name, parent: parent)
  end
end

puts "== 投稿データ投入 =="

recipes = [
   {
    title: "クランウェルツノガエルのレイアウト例",
    category_path: ["両生類", "カエル", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/bunchan/frog1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/bunchan/frog2.jpg"
    ],
    description: <<~TEXT
      【種類】クランウェルツノガエル(ブラウン)

      【使用アイテム】
      グラステラリウム3030、ソイル、軽石、コルクボード、流木、植物(水草、苔)、
      鉢底ネット、照明(アクアリウム用)

      【ポイント】
      ツノガエル類は地上性の為、低面積のあるグラステラリウム3030を使用。
      低床はソイルを敷いていますが、全てソイルを入れてしまうと底部分にカビが発生する為、
      軽石→鉢底ネット→ソイルの順番に入れていくと通気性が確保できカビ防止になります。

      成体のツノガエルは足の力が強く、低床に植えた植物等は簡単に掘り返されてしまいます。
      対策として、コルクボードに苔を活着させ背面に立てかけるようにしました。
      また水草を活着させた流木も設置し、下部分のレイアウトも補いました。
      掃除の際はコルクボードなどを取り除きケージを水洗いできるので、メンテナンス性も両立できています。

      【備考】
      今回のレイアウトでは低床に専用のフロッグソイルを使用しましたが、コストを抑えたい場合、
      園芸用の赤玉土でも代用可能です。
    TEXT
  },
  {
    title: "ヒョウモントカゲモドキのレイアウト例",
    category_path: ["爬虫類", "ヤモリ", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/leopa1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/leopa2.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/leopa3.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/leopa4.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/leopa5.jpg"
    ],
    description: <<~TEXT
      【種類】ヒョウモントカゲモドキ(ハイポタンジェリン)

      【使用アイテム】
      グラステラリウム3030、赤玉土、流木、フェイクグリーン(エアープランツ、多肉植物)、
      シェルター、小石

      【ポイント】
      本種の生息地である岩場の多い乾燥地帯を再現したレイアウトになります。
      流木を斜め〜中央に立てるように置く事で立体感を出し、
      エアープランツを適当な間隔で配置する事で実際にありそうな生息環境を意識しました。

      また野生個体は岩の隙間や穴で過ごす為、流木とシェルターが一体になるように配置し、
      シェルターの人工物感を減らすようにしました。
      底面には多肉植物、小石を置き、より自然な環境に近づけてみました。

      【備考】
      小石はアクアリウムなどで使用される安価なもので大丈夫です。
      背面はグラステラリウムシリーズの付属品である発泡スチロールのバックボードです。
      今回のレイアウトに合っていると思い使用していますが、バックスクリーンは自由に変更できます。
      シェルターはエキゾテラのレプタイルロックを使用しています。
    TEXT
  },
  {
    title: "シリケンイモリのレイアウト例",
    category_path: ["両生類", "イモリ・サンショウウオ"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/coppa/siriken1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/coppa/siriken2.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/coppa/siriken3.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/coppa/siriken4.jpg"
    ],
    description: <<~TEXT
      【種類】シリケンイモリ

      【使用アイテム】
      ヒュドラ3120、ソイル、コケ(ホソバオキナゴケ)、水入れ、流木、シェルター、鉢底ネット、照明(アクアリウム用)

      【ポイント】
      シリケンイモリのレイアウトになります。
      本種は陸棲の傾向があり、それを活かした苔リウム仕様にしました。
      苔は比較的丈夫で育成しやすいホソバオキナゴケを使用しました。
      ソイルは苔を植え込むことを考え高低差をつけ、平坦にならず奥行きが出るように敷いています。

      日々の手入れについては、苔が乾燥し過ぎてしまわないように1日2回ほど霧吹きをする必要があります。
      その際、水が底に溜まってきてしまいカビが生えてしまう恐れがあります。
      そこで画像にあるように、イモリの水入れを置く場所にピッタリ収まるように丸い空間を作りました。
      この空間を用意することで、水交換時に底に水が溜まっていたら、そこから排水しやすいように設計しています。

      【備考】
      ケージはグラステラリウム等でも可能ですが、通気性が高く乾燥しやすい為、今回はこちらを使用しました。
    TEXT
  },
  {
    title: "パンサーカメレオンのレイアウト例",
    category_path: ["爬虫類", "トカゲ", "樹上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/nico/chameleon.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/nico/chameleon2.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/nico/chameleon3.jpg"
    ],
    description: <<~TEXT
      【種類】パンサーカメレオン

      【使用アイテム】
      レプティブリーズLED DELUXE、枝流木、フェイクグリーン、バークチップ、紫外線ライト

      【ポイント】
      樹上棲である本種に向いたレイアウトになります。
      主な使用アイテムは細かく枝分かれした枝流木とフェイクグリーンなので、
      レイアウトを初めて組む方でも組みやすいシンプルな構成となっています。

      【備考】
      今回は人工のポトスを使用しましたが、アイビーなどつる性植物であれば追加しやすいと思います。
    TEXT
  }
]

def find_or_create_category_by_path(path)
  parent = nil
  path.map do |name|
    Category.find_or_create_by!(name: name, parent: parent).tap { |cat| parent = cat }
  end
end

recipes.each_with_index do |recipe_data, i|
  categories = find_or_create_category_by_path(recipe_data[:category_path])
  parent, child, grandchild = categories

  recipe = Recipe.create!(
    user: test_user,
    title: recipe_data[:title],
    description: recipe_data[:description],
    category_id: parent&.id,
    child_category_id: child&.id,
    grandchild_category_id: grandchild&.id
  )

  recipe_data[:image_urls].each do |url|
    begin
      file = URI.open(url)
      recipe.images.attach(io: file, filename: File.basename(url))
    rescue => e
      puts "画像の取得に失敗しました: #{url} (#{e.message})"
    end
  end

  puts "(#{i + 1}/#{recipes.length}) #{recipe.title} 作成完了"
end

puts "== Seedデータ投入完了 =="
