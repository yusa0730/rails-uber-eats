module Api
  module V1
    class LineFoodsController < ApplicationController
      # p %i(samurai, blog, Ruby)
      # 実行結果 [:samurai, :blog, :Ruby]
      # onlyオプションをつけることで、特定のアクションの実行前にだけ追加するということができます。
      # before_actionではそのコントローラーのメインアクションに入る"前"におこなう処理を挟むことができる。
      # これをcallbackという。
      before_action :set_food, only: %i[create]

      # 仮注文を作成するメソッド(create)
      # パラメーターには「どのフード？」、また「それをいくつ？(数量)」という２つが必要です。
      def create
        # 「他店舗でアクティブなLineFood」をActiveRecord_Relationのかたちで取得します
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name
          }, status: :not_acceptable
        end

        set_line_food(@ordered_food)

        # @line_food.saveが成功した場合、status: :createdと保存したデータを返します。
        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json:{}, status: :internal_server_error
        end
      end


      # 作成された仮注文一覧を取得するメソッド(index)です。
      # ここではフロントエンドで必要なデータもあわせてJSON形式で返すようにします。
      def index        
      end

      # 店舗Aで仮注文後に店舗Bで別の仮注文を作成しようとするケースです。
      # この場合には、前者(店舗A)を消して、後者の新しいものに置き換える(replace)という仕様でした。
      def replace        
      end

      private

      def set_food
        # グローバル変数に代入しています。
        # こうすることで、このあと実行されるcreateアクションの中でも@ordered_foodを参照することができます。
        @ordered_food = Food.find(params[:food_id])
      end

      # ここで作成・更新された@line_foodはまだDBに保存されていないことに注意。
      def set_line_food(ordered_food)
        # すでに同じfoodに関するline_foodが存在する場合
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          # 新しくline_foodを生成する場合。
          # build_associationメソッドは、関連付けられた型の新しいオブジェクトを返します。
          # 返されるオブジェクトは、渡された属性に基いてインスタンス化され、外部キーを経由するリンクが設定されます。
          # 関連付けられたオブジェクトは、値が返された時点ではまだ保存されていないことにご注意ください。
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end