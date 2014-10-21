class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :login_key

      t.timestamps
	  
	  t.index :login_key, :unique => true
    end
	
  end
end
