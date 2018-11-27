class User < ApplicationRecord
    include RailsJwtAuth::Authenticatable
    include RailsJwtAuth::Recoverable
    include RailsJwtAuth::Invitable

    enum role: { user: 0, admin: 1 }

    # Used to define cancan ability
    def is?(role)
        self.role.to_sym == role
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
