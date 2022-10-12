class CreateStreets < ActiveRecord::Migration[6.1]
  def change
    create_table :streets do |t|
      t.string :title, null: false
      t.integer :from
      t.integer :to

      t.timestamps
    end
    add_index :streets, :title
  end
end
