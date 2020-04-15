class ApplicationController < ActionController::API
    def authenticate
        token = request.headers['Authorization'].split(' ')[1]

        if !token
            render json: { message: "no token, braddah" }, status: :unauthorized
        else
            secret = Rails.application.secret_key_base
            begin
                payload = JWT.decode(token, secret)[0]
                @user = User.find(payload["user_id"])
            rescue
                render json: { message: "couldn't decode it braddah" }, status: :unauthorized
            end
        end
    end
end
