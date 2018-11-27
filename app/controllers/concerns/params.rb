module Params
    include RailsJwtAuth::ParamsHelper

    #You can overwrite RailsJwtAuth::ParamsHelper to customize controllers strong parameters.
    #See gem params_helper.rb to get the params name method
    
    def invitation_create_params
        params.require(:invitation).permit(:email, :role, :name)
    end
end