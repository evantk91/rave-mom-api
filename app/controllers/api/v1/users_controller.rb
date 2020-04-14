class UsersController < ApplicationController
    def index
        @users = User.all
        render json: { user: UserSerializer.new(@users) }
    end

    def create
        @user = User.create(user_params)

        if @user.valid?
            render json: { user: UserSerializer.new(@user) }, status: :created
        else
            render json: {error: "password needs to be 5 characters or more"}, status: :bad_request
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :password)
    end
end
