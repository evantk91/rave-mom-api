class Api::V1::ScoresController < ApplicationController
    before_action :authenticate, only: [:index, :create]

    def index
        @scores = Score.all
        render json: @scores, include: [:user]
    end

    def create
        @score = @user.scores.create(score_params)
        if @score.persisted?
            render json: @score
        else
            render json: @score.errors, status: :unprocessable_entity
        end
    end

    private
    def score_params
        params.require(:score).permit(:score)
    end
end
