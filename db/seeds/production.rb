require "open-uri"

puts " 既存データ削除中..."
Like.destroy_all
Recipe.destroy_all
Category.destroy_all
User.where(email: "test@example.com").destroy_all
puts " 削除完了"

test_user = User.create!(
  name: "テスト",
  email: "test@example.com",
  password: "password123"
)
puts " テストユーザー作成完了"

recipes = [
  {
    title: "ブンちゃん",
    category_path: ["両生類", "カエル", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/bunchan/bunchan1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/bunchan/bunchan2.jpg"
    ],
    description: <<~TEXT
      【種類】クランウェルツノガエル
      【品種】アルビノ
      【コメント】2020年12月に家に来た
    TEXT
  },
  {
    title: "コッパ",
    category_path: ["両生類", "カエル", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/coppa/coppa1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/coppa/coppa2.jpg"
    ],
    description: <<~TEXT
      【種類】クランウェルツノガエル
      【品種】ブラウン
      【コメント】2020年12月に家に来た
    TEXT
  },
  {
    title: "レオパンヌ",
    category_path: ["爬虫類", "ヤモリ", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/leopannu1.jpg"
    ],
    description: <<~TEXT
      【種類】ヒョウモントカゲモドキ
      【品種】マックスノー
      【コメント】2021年4月に家に来た
    TEXT
  },
  {
    title: "イモリーヌ",
    category_path: ["両生類", "イモリ・サンショウウオ"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/imorienu1.jpg"
    ],
    description: <<~TEXT
      【種類】アカハライモリ
      【品種】特になし
      【コメント】2023年9月に家に来た
    TEXT
  },
  {
    title: "ゴマりん",
    category_path: ["小動物", "ハムスター"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/gomarin.jpg"
    ],
    description: <<~TEXT
      【種類】ゴールデンハムスター
      【品種】ダルメシアン
      【コメント】2024年3月に家に来た
    TEXT
  },
  {
    title: "フェルン",
    category_path: ["爬虫類", "ヤモリ", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/ferun1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/ferun/ferun2.jpg"
    ],
    description: <<~TEXT
      【種類】ヒョウモントカゲモドキ
      【品種】インフェルノ
      【コメント】2024年10月に家に来た
    TEXT
  },
  {
    title: "ポチャコ",
    category_path: ["両生類", "カエル", "地上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/pochaco/pochaco1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/pochaco/pochaco2.jpg"
    ],
    description: <<~TEXT
      【種類】チャコガエル
      【品種】特になし
      【コメント】2024年10月に家に来た
    TEXT
  },
  {
    title: "ニコ",
    category_path: ["爬虫類", "ヤモリ", "樹上棲"],
    image_urls: [
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/nico/nico1.jpg",
      "https://terra-space.s3.ap-southeast-1.amazonaws.com/portfolio/nico/nico2.jpg"
    ],
    description: <<~TEXT
      【種類】グランディスヒルヤモリ
      【品種】特になし
      【コメント】2024年11月に家に来た
    TEXT
  }
]

def find_or_create_category_by_path(path)
  parent = nil
  path.map do |name|
    Category.find_or_create_by!(name: name, parent: parent).tap do |cat|
      parent = cat
    end
  end
end

puts "レシピ作成中..."

ActiveRecord::Base.transaction do
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
end

puts " Seedデータ投入完了"
