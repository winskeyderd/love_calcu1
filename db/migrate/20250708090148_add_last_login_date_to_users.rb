class AddLastLoginDateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_login_date, :date
  end
end
