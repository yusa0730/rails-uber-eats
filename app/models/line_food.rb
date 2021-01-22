class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true

  validates :count, numericality: { greater_than: 0 }

  # Railsのscopeはモデルそのものや関連するオブジェクトに対するクエリを指定することができます。
  # その返り値は必ずActiveRecord::Relationオブジェクトを返します。
  # 下記のscopeでは全てのLineFoodからwhereでactive: trueなもの一覧をActiveRecord_Relationのかたちで返してくれます。
  scope :active, -> { where(active: true)}

  # restaurant_idが特定の店舗IDではないもの一覧を返してくれます。
  # つまり、「他の店舗のLineFood」があるかどうか？をチェックする際にこのscopeを利用します。
  # もし「他の店舗のLineFood」があった場合、ここには１つ以上の関連するActiveRecord_Relationが入ります。
  scope :other_restaurant, -> (picked_restaurant_id) {where.not(restaurant_id: picked_restaurant_id)}

  def total_price
    food.price * count
  end
end