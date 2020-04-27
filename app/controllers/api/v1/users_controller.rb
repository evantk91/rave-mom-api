class Api::V1::UsersController < ApplicationController
    def index
        @users = User.all
        render json: @users
    end

    def show
        @user = User.find(params[:id])
        render json: @user
    end

    def create
        @user = User.new(
            username: params[:username],
            password: params[:password]
        )

        if @user.save
            render json: @user, status: :created
        else
            render json: { error: 'failed to create user' }, status: :bad_request
        end
    end
end
