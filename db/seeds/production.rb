require "open-uri"

puts "Start seeding production data..."

test_user = User.find_or_create_by!(email: "test@example.com") do |user|
  user.name = "テスト"
  user.password = "password123"
end

def find_category_path(names)
  names.inject(nil) do |parent, name|
    Category.find_by!(name: name, parent: parent)
  end
end

def create_recipe(title:, category_path:, image_urls:, description:, user:)
  grandchild = find_category_path(category_path)
  child = grandchild.parent
  root  = child&.parent

  recipe = Recipe.create!(
    title: title,
    description: description,
    category_id: root&.id,
    child_category_id: child&.id,
    grandchild_category_id: grandchild.id,
    user: user
  )

  downloaded_images = image_urls.map do |url|
    filename = File.basename(URI.parse(url).path)
    file = URI.open(url)
    { io: file, filename: filename, content_type: "image/jpeg" }
  end

  Recipes::ImagesAttachmentService.new(recipe, downloaded_images).attach

  recipe
end

recipes = [
  {
    title: "ブンちゃん",
    category_path: ["両生類", "カエル", "地上棲"],
    image_urls: [
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/bunchan/bunchan1.jpg",
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/bunchan/bunchan2.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/coppa/coppa1.jpg",
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/coppa/coppa2.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/leopannu1.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/imorienu1.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/gomarin.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/ferun/ferun1.jpg",
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/ferun/ferun2.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/pochaco/pochaco1.jpg",
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/pochaco/pochaco2.jpg"
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
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/nico/nico1.jpg",
      "https://your-s3-bucket.s3.amazonaws.com/terra-space/portfolio/nico/nico2.jpg"
    ],
    description: <<~TEXT
      【種類】グランディスヒルヤモリ
      【品種】特になし
      【コメント】2024年11月に家に来た
    TEXT
  }
]

recipes.each do |data|
  create_recipe(**data, user: test_user)
end

puts "✅ Production seeds complete!"
