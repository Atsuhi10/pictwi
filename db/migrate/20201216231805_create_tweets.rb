class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.string  :user_name
      t.text    :tweet_text
      t.text    :image_url
      t.timestamps
    end
  end
end
