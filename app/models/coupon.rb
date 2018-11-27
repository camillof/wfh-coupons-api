class Coupon < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true

  validates :requested_date, presence: true, uniqueness: { scope: :user, message: "for that user already exists" }

  before_create :set_default_status

  enum status: { pending: 0, approved: 1, rejected: 2 }

  scope :by_month, -> (month_number) { where ("MONTH(requested_date) = ?"), month_number } 
  scope :by_status, -> (status) { where status: status }
  scope :by_user_id, -> (user_id) { where user_id: user_id }

  def set_default_status
    self.status ||= Coupon.statuses[:pending] 
  end

  def approve!(user_id)
    user = User.find(user_id)
    self.update!(status: Coupon.statuses[:approved], approved_by: user, approved_date: Time.now) 
  end

  def reject!
    self.update!(status: Coupon.statuses[:rejected])
  end

end
