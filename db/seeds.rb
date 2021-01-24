3.times do |n|
  restaurant = Restaurant.new(
    name: "testレストラン_#{n}",
    fee: 100,
    time_required: 10,
  )

  12.times do |m|
    restaurant.foods.build(
      name: "フード名_#{m}",
      price: 500,
      description: "フード_#{m}の説明文です。"
    )
  end

  # 破壊的メソッド
  # エラーが発生した場所、原因が拾いやすい
  # 例外が起きた場所で処理を止められる
  # )tanaka.save # => false
  # tanaka.save! # => ActiveRecord::RecordInvalid: Validation failed: Name can't be blank
  restaurant.save!
end