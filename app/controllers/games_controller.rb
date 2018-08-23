class GamesController < ApplicationController
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :game_not_found

  def create
    @game = Game.create

    # TODO fix client side to send Accept: application/json so we can use responders
    #respond_with @game
    render :create
  end

  def show
    @game = Game.where(id: params[:id]).first!

    respond_with @game
  end

  private

  def game_not_found
    render json: { message: 'Game was not found' }, status: 404
  end
end
