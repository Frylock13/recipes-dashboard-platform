class CreateGlasses < ActiveRecord::Migration[5.0]
  def change
    create_table :glasses do |t|
      t.string :name
      t.string :slug
      t.integer :recipes_count

      t.timestamps
    end
  end
end
