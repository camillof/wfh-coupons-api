class Api::UsersController < ApplicationController
    before_action :authenticate!
    load_and_authorize_resource only: [:index]

    def index
         json_response(@users.to_json)
    end

end