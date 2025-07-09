class CreateUserReadings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_readings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :person1_first
      t.string :person1_last
      t.string :person2_first
      t.string :person2_last
      t.string :result

      t.timestamps
    end
  end
end
