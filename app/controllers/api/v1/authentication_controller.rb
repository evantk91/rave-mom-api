class Api::V1::AuthenticationController < ApplicationController
    def login
        @user = User.find_by(username: params[:username])

        if !@user
            render status: :unauthorized
        else
            if !@user.authenticate(params[:password])
                render status: :unathorized
            else
                secret = Rails.application.secret_key_base
                payload = { user_id: @user.id }
                token = JWT.encode(payload, secret)
                @scores = Score.all.map do |score| 
                    {
                        score: score.score,
                        user: @user.username
                    }      
                end

                render json: { token: token, user_id: @user.id, scores: @scores }
            end    
        end
    end
end
