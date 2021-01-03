class UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    @nickname = user.nickname
    @tweets = user.tweets.order("created_at DESC").page(params[:page]).per(5)
    # パスの一部で指定されたidのユーザーに紐づいたTweetテーブルのインスタンスをビューへ渡す。
    # アソシエーションを利用しない場合は次の書き方になる。
##  @tweets = Tweet.where(user_id: user.id).order("created_at DESC")
    # whereはActiveRecordメソッドの一つであり、カッコ内の条件に一致したレコードのインスタンスを配列型で取得する。
  end
  # ユーザーのプロフィール表示ではなく投稿一覧なのだからむしろindexの方が適当なのではないか。
  
end
