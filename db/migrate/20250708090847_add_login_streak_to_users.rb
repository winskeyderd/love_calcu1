class AddLoginStreakToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :login_streak, :integer
  end
end
