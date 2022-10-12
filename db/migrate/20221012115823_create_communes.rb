class CreateCommunes < ActiveRecord::Migration[6.1]
  def change
    create_table :communes do |t|
      t.string :name, null: false
      t.integer :population
      t.string :code_insee, null: false
      t.references :intercommunality, null: false, foreign_key: true

      t.timestamps
    end
    add_index :communes, :code_insee
  end
end
