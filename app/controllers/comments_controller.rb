class CommentsController < ApplicationController
  def create
    new_comment = comments_params
    new_comment["user_id"] = current_user.id
    c = Comment.create(new_comment)
    redirect_to "/tweets/#{c.tweet.id}"
    # コメントが属するツイートの詳細画面に遷移させる
  end
  
  def destroy
    c = Comment.find(params[:id])
    tweet_id = c.tweet.id
    c.destroy if user_signed_in? && c.user_id == current_user.id
    redirect_to "/tweets/#{tweet_id}"
  end
  
  private
  def comments_params
    params.permit(:text, :tweet_id)
    # app/views/tweets/show.html.erb内のform_tagから受け取った情報を返す。
    # ネストのルーティングによりキー:tweet_idで各々のCommentクラスのインスタンスが属するツイートのidを取得できる。
  end
end
