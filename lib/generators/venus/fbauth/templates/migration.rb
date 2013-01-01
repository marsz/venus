class AddColumnsForFbloginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, :after => :email
    add_column :users, :facebook_id, :string, :after => :email
    add_index :users, [:facebook_id]
  end
end