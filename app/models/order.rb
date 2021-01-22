class Order < ApplicationRecord
  # 注文自体はどの店舗に対して、いくらの金額を払うか？ということのみを保持するようにします。
  has_many :line_foods
  # https://railsguides.jp/association_basics.html
  # 
  has_one :restaurant, through: :line_food

  validates :total_price, numericality: {greater_than: 0}

  def save_with_update_line_foods!(line_foods)
    # これらの処理をトランザクションの中で行うようにすることで、この２つの処理のいずれかが失敗した場合に全ての処理をなかったことにするように配慮しています。
    ActiveRecord::Base.transaction do
      line_foods.each do |line_food|
        # LineFoodデータの更新
        # update_attributes  → falseを返す
        # update_attributes! → 例外を投げる
        line_food.update_attributes!(active: false, order: self)
      end
      # Orderデータの保存を処理しています。
      self.save!
    end
  end
end