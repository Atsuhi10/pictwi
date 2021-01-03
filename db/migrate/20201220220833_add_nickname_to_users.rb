class AddNicknameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nickname, :string
    # migrateコマンドで当メソッドが実行される。
  end
end
