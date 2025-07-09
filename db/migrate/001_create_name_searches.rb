class CreateNameSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :name_searches do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :search_count, default: 1
      t.timestamps
    end

    add_index :name_searches, [:first_name, :last_name], unique: true
  end
end
