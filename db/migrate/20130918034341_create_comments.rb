class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.integer :menu_item_id, null: false

      t.timestamps
    end
  end
end
