class Coupon < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true

  validates :requested_date, presence: true, uniqueness: { scope: :user, message: "for that user already exists" }

  before_create :set_default_status, :send_request_email

  enum status: { pending: 0, approved: 1, rejected: 2 }

  scope :by_month, -> (month_number) { where ("MONTH(requested_date) = ?"), month_number } 
  scope :by_status, -> (status) { where status: status }
  scope :by_user_id, -> (user_id) { where user_id: user_id }
  scope :by_year, -> (year_number) { where ("YEAR(requested_date) = ?"), year_number } 

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

  def send_request_email
    UserNotifierMailer.alert_email(self.user).deliver
  end

  def send_request_notification
    SlackClient.send_notification("#{user.name} requested working from home on #{requested_date.to_s(:long)}")
  end

  def send_response_notification
    UserNotifierMailer.alert_email_response(self.user,self.answer_test).deliver
  end

  

end
