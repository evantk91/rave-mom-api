class Api::V1::ScoresController < ApplicationController
    before_action :authenticate, only: [:index, :create]

    def index
        @scores = Score.all
        render json: @scores
    end

    def create
        @score = Score.create(
            user_id: params[:user_id],
            score: params[:score]
        )

        render json: @score
    end
end
