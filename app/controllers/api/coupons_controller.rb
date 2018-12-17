class Api::CouponsController < ApplicationController
    before_action :authenticate!
    load_and_authorize_resource

    def index
        json_response(@coupons.filter(filtering_params))
    end

    def create
        @coupon.save!
        json_response(@coupon)
        @coupon.send_request_notification
    end

    def destroy
        @coupon.destroy!
    end

    def approve
        @coupon.approve!(current_user.id)
        json_response(@coupon)
    end

    def reject
        @coupon.reject!
        json_response(@coupon)
    end


    private 

    def filtering_params
        params.permit(:by_month, :by_status, :by_user_id, :by_year)
    end

    def coupon_params
        params.permit(:user_id, :requested_date)
    end
end