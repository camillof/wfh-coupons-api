class User < ApplicationRecord
    include RailsJwtAuth::Authenticatable
    include RailsJwtAuth::Recoverable
    include RailsJwtAuth::Invitable
    
    #has_many :coupons

    enum role: { user: 0, admin: 1 }

    # Used to define cancan ability
    def is?(role)
        self.role.to_sym == role
    end

    def ccoupons()        
         Coupon.by_user_id(self.id).by_year(Time.current.year).by_month(Time.current.month).count;        
    end

    def to_json(options={})
        super(:only => [:name, :email, :id, :role,:active],:methods => [:ccoupons])
    end

    def as_json(options={})
        super(:only => [:name, :email, :id, :role,:active],:methods => [:ccoupons])
    end
    # Overrides RailsJwtAuth payload
    def to_token_payload(request)
        {
            auth_token: regenerate_auth_token,
            user: {
                id: self.id,
                name: self.name,
                role: self.role,
                active: self.active
            }
        }
    end
end
