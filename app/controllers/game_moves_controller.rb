class GameMovesController < ApplicationController
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :game_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_move
  rescue_from MoveService::MoveError, with: :invalid_move

  before_action :find_game

  def create
    service = MoveService.new(@game, params[:subgame].to_i, params[:cell].to_i)
    service.make_move!

    # TODO fix client side to send Accept: application/json so we can use responders
    #respond_with @game
    render :create
  end

  private

  def find_game
    @game = Game.where(id: params[:id]).first!
  end

  def invalid_move(error)
    case error
    when MoveService::InvalidSubGame
      render json: { message: 'Invalid subgame' }
    when MoveService::InvalidCell
      render json: { message: 'Invalid cell' }
    when MoveService::CellOccupied
      render json: { message: 'Cell occupied' }
    when ActiveRecord::RecordInvalid
      render json: { message: error.message }
    end
  end

  # TODO DRY this up with GamesController
  def game_not_found
    render json: { message: 'Game was not found' }, status: 404
  end
end
