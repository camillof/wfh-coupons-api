class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :google_authorization, :string      
  end
end