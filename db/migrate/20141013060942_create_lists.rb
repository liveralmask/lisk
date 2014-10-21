class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :account_id
      t.string :str

      t.timestamps
    end
  end
end
