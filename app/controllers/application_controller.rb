class ApplicationController < ActionController::API
    include RailsJwtAuth::WardenHelper
    include Response
    include ExceptionHandler
    include Params
end
