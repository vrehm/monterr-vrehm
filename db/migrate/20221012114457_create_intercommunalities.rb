class CreateIntercommunalities < ActiveRecord::Migration[6.1]
  def change
    create_table :intercommunalities do |t|
      t.string :form
      t.string :name, null: false
      t.integer :population
      t.string :siren, null: false
      t.string :slug, null: false

      t.timestamps
    end
    add_index :intercommunalities, :siren, unique: true
  end
end
