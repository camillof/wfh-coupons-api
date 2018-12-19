class Api::InvitationsController < RailsJwtAuth::InvitationsController
    before_action :authenticate!, only: [:create]
end
