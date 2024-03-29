class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Create a new game
  def create
    @game = Game.new
    if @game.save
      render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # generate the score for each game
  def score
    @game = Game.find(params[:id])
    total_scores = @game.score(@game)
    render json: { scores: total_scores }
  end
end
