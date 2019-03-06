class UpdateCoupons < ActiveRecord::Migration[5.2]
  def change
    add_column :coupons, :answer_test, :string
    add_column :coupons, :request_type, :integer, :default => 0    
    add_column :coupons, :date_to, :date       
  end
end