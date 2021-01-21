class Food < ApplicationRecord
  belongs_to :restaurant
  belongs_to :order, optional: true
  # LineFoodモデルとは1:1の関係にあるのでhas_oneを定義します
  # foodsとline_foodsは1:1の関係にあり、１つのfoodsにつき１つのline_foodsが存在します。
  has_one :line_food
end