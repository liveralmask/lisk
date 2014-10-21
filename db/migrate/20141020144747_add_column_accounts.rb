class AddColumnAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :account_key, :string
  end
end
