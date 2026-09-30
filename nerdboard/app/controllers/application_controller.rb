class ApplicationController < ActionController::API
    private 

    def authenticate_request
        token = request.headers["Authorization"]&.split(" ")&.last
        @current_user =User.find_by(api_token: token)

        render json: {error: "Niet ingelogd"}, status: :unauthorized unless @current_user
    end
end
