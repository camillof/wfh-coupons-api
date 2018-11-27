class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.integer :role, default: 0
      t.boolean :active, default: true
      t.string :password_digest
      t.string :auth_tokens
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :invitation_token
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.datetime :invitation_created_at
      t.timestamps
    end
  end
end
