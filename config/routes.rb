Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root  'tweets#index'
  resources :tweets do
    resources :comments, only: [:create, :destroy]
    # ルーティングのネスト
  end
  resources :users, only: [:show]
  # See the controllers in app/controllers/ to find all defined actions 
  
=begin
  resourcesメソッドを使用しないで個別にルーティング設定する場合
  get   'tweets' => 'tweets#index' # 一覧表示
  get   'tweets/:id' => 'tweets#show' # 詳細表示
  get   'tweets/new' => 'tweets#new' # 投稿画面
  post  'tweets' => 'tweets#create' # 新規投稿
  # See form_tag in app/views/tweets/new.html.erb which commands 'post' method
  # 'tweets#create' on right-hand side refers 'create' action in app/controllers/tweets_controller.rb and app/views/tweets/create.html.erb
  
  delete 'tweets/:id' => 'tweets#destroy' # 削除
  get 'tweets/:id/edit' => 'tweets#edit' # 編集画面
  patch 'tweets/:id' => 'tweets#update' # 修正投稿
  
  get   'users/:id' => 'users#show' # マイページ
  # ':id' in path will be written as a integer which functions as a parameter and will be refered in the action on RHS. 
=end
end
