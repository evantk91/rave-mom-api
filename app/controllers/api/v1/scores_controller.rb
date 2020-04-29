class Api::V1::ScoresController < ApplicationController
    before_action :authenticate, only: [:index, :create]

    def index
        @scores = Score.all
        render json: @scores, include: [:user]
    end

    def create
        @score = Score.create(score_params)
        render json: @score
    end

    private
    def score_params
        params.require(:score).permit(:score)
    end
end
