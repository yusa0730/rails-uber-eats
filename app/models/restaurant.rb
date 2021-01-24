class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods
  # optionalをtrueにすることで関連付けが任意になります。
  # つまり、関連付け先が存在しなくてもいいという意味です。
  belongs_to :order, optional: true

  # :nameや:feeなどのカラムのデータが必ず存在する(存在しないとエラーになる)ことを定義しています。
  validates :name, :fee, :time_required, presence: true
  validates :name, length: { maximum: 30 }
  # こちらは:fee、つまり手数料が0以上であることと制限しています。
  # 配送手数料なので誤って-100などのマイナスの値が入ってしまうことを防ぐ意図があります。
  validates :fee, numericality: { greater_than: 0 }
end