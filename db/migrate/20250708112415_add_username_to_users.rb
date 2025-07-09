class AddUsernameToUsers < ActiveRecord::Migration[6.1] # or your version
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
  end
end
