class CreateLoveTests < ActiveRecord::Migration[7.1]
  def change
    create_table :love_tests do |t|
      t.string :given_name_a
      t.string :surname_a
      t.string :given_name_b
      t.string :surname_b

      t.timestamps
    end
  end
end
