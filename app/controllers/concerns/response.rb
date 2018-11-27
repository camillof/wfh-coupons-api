module Response
    include RailsJwtAuth::RenderHelper

    def render_session(jwt, user)
        json_response({session: {jwt: jwt, user: UserSerializer.new(user)}})
    end

    def json_response(object, status = :ok)
        render json: object, status: status
    end
end