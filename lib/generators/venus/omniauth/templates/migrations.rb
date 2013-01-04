class AddIndexForAuthorizationsAndAddColumnForUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, :after => :email
    add_index :authorizations, [:provider, :uid]
    add_index :authorizations, [:auth_type, :auth_id]
  end
end
