class CouponSerializer < ActiveModel::Serializer
    attributes :id, :status, :requested_date, :approved_date, :created_at, :user_id

    belongs_to :user
    belongs_to :approved_by

    
end