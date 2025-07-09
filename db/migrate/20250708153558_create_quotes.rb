class CreateQuotes < ActiveRecord::Migration[7.1]
  def change
    create_table :quotes do |t|
      t.text :quote
      t.string :author
      t.boolean :active

      t.timestamps
    end
  end
end
