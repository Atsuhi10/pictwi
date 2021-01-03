class TweetsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  # before_action :(同一コントローラ内の)メソッド名
  # という形の記述で、コントローラのアクションの実行前に指定したメソッドを実行する。
  # 例外としてindexアクションが呼ばれている場合はこの行を飛ばす。
  
  def index
    # 原則としてRailsではアクションの処理が終わると同時に同名のビューが呼ばれる。
    # 例えばこのアクションの後にはapp/views/tweets/index.html.erbが読み込まれる。
    
    @posts = Tweet.includes(:user).order("created_at DESC").page(params[:page]).per(5)
    # インスタンス変数にTweetsテーブルから抜き出した情報を代入している。
    # このときincludesメソッドを利用してアソシエーションの組まれたusersテーブルのレコードを同時に取得している。
    # こうすることで個別のインスタンスを表示しようとする度にデータベースから情報を抽出する（SQLを発行する）ことで生じる「n+1問題」を回避する。
    # さらにorderメソッドでインスタンスを作成日時の新しい順に並び替え、
    # kaminariのメソッドを使用してparamsで指定した番号のページのインスタンス5件のみをビューへ渡している。
  end
  
  def show
    @tweet = Tweet.find(params[:id])
    # 詳細を表示させたいインスタンスを抽出してビューへ渡す。
    # インスタンスのidはハッシュparamsに自動的に格納される。
    # そのキーはroutes.rbに書かれた'tweets/:X'の中のX (通常はid)であり、値はリクエストで渡されるパス/tweets/xxの中のinteger xになる。
    
    if @tweet.user.nil?
      @signature = @tweet.user_name + "（サンプル）"
    else
      @signature = @tweet.user.nickname
      if not @tweet.user_name.strip.empty?
        @signature += " as " + @tweet.user_name
      end
    end
    # 独自仕様：ユーザー名とは別に投稿毎にニックネームが設定可能になっていて、
    # ニックネームが登録されていればユーザ名とニックネームの両方を併記させる。
    # サインアップ実装前に作成したインスタンスの表示には（サンプル）を付ける。
    
    @comments = @tweet.comments.includes(:user)
    # そのtweetに属するCommentテーブルのレコードを取得し、
    # さらにincludesメソッドで各コメントが属するUserテーブルのレコードを同時に取得してビューへ渡す。
    # 該当するレコードがなければnilとなる。
  end
  
  def new
    # 投稿画面を表示させたいだけなのでリソースを処理する記述なし
  end
  
  def create
    new_tweet = tweet_params
    
    if user_signed_in?
      new_tweet["user_id"] = current_user.id
      # current_userはログイン中のユーザーの情報をUserクラスのインスタンスとして取得するdeviseのメソッド。
      # ここではuserテーブルのカラム名user_idをキーとして当該のUserインスタンスのIDを取得しハッシュnew_tweetに新しいキーの値として追加している。
      
      new_tweet["user_name"] = current_user.nickname if new_tweet["user_name"].strip.empty?
      # 新規登録画面でNicknameを入力しなかった場合はユーザー名をニックネームとして使う。
      
      Tweet.create(new_tweet)
      # この行のcreateはApplicationControllerのメソッドであり、ハッシュ形式の引数をTweetモデルに通してデータベースに保存させる。
    end
  end
  
  def destroy
    t = Tweet.find(params[:id])
    t.destroy if user_signed_in? && t.user_id == current_user.id
    # ルーティングに'tweets/:id'という記述があるためparamsにidというキーが追加されてそこにtweetテーブルのレコードのidが入る。
    # その値を使ってTweetテーブルのレコードを抽出する。
    # もし投稿者とログイン中のユーザーが一致すればdestroyメソッドを実行してレコードの削除を行う。
  end
  
  def edit
    @tweet = Tweet.find(params[:id])
    # 編集対象のインスタンスを抽出してビューへ渡す。
  end
  
  def update
    t = Tweet.find(params[:id])
    new_tweet = tweet_params
    
    if user_signed_in?
      new_tweet["user_name"] = current_user.nickname if new_tweet["user_name"].strip.empty?
      t.update(new_tweet)
      # この行のupdateはApplicationControllerのメソッドであり、ハッシュ形式の引数をTweetモデルに通してデータベースに保存させる。
    end
  end
  
  private
  # この先のメソッドは本コントローラーのアクションでしか呼び出さないのでprivate宣言を行う
  def move_to_index
    redirect_to action: :index unless user_signed_in?
    # ハッシュを引数に持ちアクション名と別名のアクションやビューを呼ぶメソッド。
    # 本来なら引数は{ action: :index }と書くがRails内では括弧を省略できる。
    # 条件として一行で書くunlsee文でログインしてない場合のみ実行するとしている。
  end
  
  def tweet_params
    # params自体はユーザーの入力した情報を含むハッシュを返すActonControllerのメソッドで、
    # 次の行はその中の指定したキーの値の操作を許可（permit）することを意味する。
    params.permit(:user_name, :tweet_text, :image_url)
    # 逆に言えばこれ以外のキー（システム・環境に関わる）はユーザー側の操作で変更・保存できない。
    # この仕組みをストロングパラメータという。
    # 本メソッドが返すのは、例えば
    # {"user_name"=>"Taro", "tweet_text"=>"こんにちは", "image_url"=>"https://abc.com/pic.jpg"}
    # のようなハッシュである。
    # 引数に書かれるキーはデータベースのカラム名やビューファイルのform_tag内のname属性の値に一致させる。
  end
end
