class Api::CouponsController < ApplicationController
    before_action :authenticate!, only: [:index,:create,:destroy,:approve,:reject,:callback]
    load_and_authorize_resource only: [:index,:create,:destroy,:approve,:reject,:callback]

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
        begin            
        @coupon.approve!(current_user.id)
        json_response(@coupon)
        @coupon.answer_test = "Tu solicitud ha sido aprobada"
        @coupon.send_response_notification
        add_event_to_calendar
        rescue Google::Apis::AuthorizationError
            #response = client.refresh!        
            #session[:authorization_google] = session[:authorization_google].merge(response)    
            redirect
        retry
        end
    end
    
    def reject
        @coupon.reject!
        json_response(@coupon)
        @coupon.answer_test = "Tu solicitud ha sido rechazada. El comentario del administrador es:"+@coupon.answer_test
        @coupon.send_response_notification
    end

    
    def callback        
        client = Signet::OAuth2::Client.new(client_options)
        client.code = params[:code]
        response = client.fetch_access_token!
        current_user.google_authorization = response
        session[:authorization] = response
        current_user.save      
        json_response({'data': "http://localhost:4200/admin/manage-coupons"}) 
    end
    
    def redirect
        client = Signet::OAuth2::Client.new(client_options)         
        json_response({'data':client.authorization_uri.to_s})
    end
      
    def add_event_to_calendar
        begin
            name_person = @coupon.user.name
        
            client = Signet::OAuth2::Client.new(client_options)
            client.update!(ActiveSupport::JSON.decode(current_user.google_authorization.gsub! '=>', ':'))            
            service = Google::Apis::CalendarV3::CalendarService.new
            service.authorization = client
        
            today = @coupon.requested_date
            end_day = @coupon.date_to
        
            if (@coupon.request_type == 0)
                type = 'Trabajo Remoto de '+name_person
                end_day = today
            else
                type = 'Licencia'+name_person
            end

            event = Google::Apis::CalendarV3::Event.new({
                start: Google::Apis::CalendarV3::EventDateTime.new(date: today),
                end: Google::Apis::CalendarV3::EventDateTime.new(date: end_day),
                summary: type
            })
        
            calendar = nil
            calendars = service.list_calendar_lists
            calendars.items.each do |e|
                if e.summary=="Kreitech-Team"
                    calendar = e;
                end
              end            
            service.insert_event(calendar.id, event)

            
        end           
    end

    private 

    def client_options
        {
          client_id: ENV['google_client_id'],
          client_secret: ENV['google_client_secret'],
          authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
          token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
          redirect_uri: "http://localhost:4200/admin/redirect-google"
        }
    end

    def filtering_params
        params.permit(:by_month, :by_status, :by_user_id, :by_year)
    end

    def coupon_params
        params.permit(:user_id, :requested_date, :date_to)
    end
end