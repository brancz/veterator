class CreateAuthenticationTokens < ActiveRecord::Migration
  def change
    create_table :authentication_tokens do |t|
      t.string :token
      t.datetime :valid_until
      t.integer :user_id

      t.timestamps
    end
    add_index :authentication_tokens, :token
  end
end
