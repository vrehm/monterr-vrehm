class CreateCommuneStreets < ActiveRecord::Migration[6.1]
  def change
    create_table :commune_streets do |t|
      t.references :street, null: false, foreign_key: true
      t.references :commune, null: false, foreign_key: true

      t.timestamps
    end
  end
end
