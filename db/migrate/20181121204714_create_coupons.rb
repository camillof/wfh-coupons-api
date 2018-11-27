class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :status, default: 0
      t.date :requested_date
      t.date :approved_date
      t.integer :approved_by_id

      t.timestamps
    end
  end
end
