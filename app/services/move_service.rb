class MoveService
  MoveError = Class.new(StandardError)
  InvalidSubGame = Class.new(MoveError)
  InvalidCell = Class.new(MoveError)
  CellOccupied = Class.new(MoveError)

  def initialize(game, subgame, cell)
    raise InvalidSubGame unless subgame.in? game.valid_subgames
    raise InvalidCell if cell < 0 || cell > 8

    @game = game
    @subgame = subgame
    @cell = cell
  end

  def make_move!
    update_game_board
    update_won_subgames
    update_valid_subgames

    check_for_winner_and_update_turn

    @game.save!
  end

  private

  delegate :board, to: :@game

  def update_game_board
    raise CellOccupied if board[@subgame][@cell].in? Game::PLAYERS

    board[@subgame][@cell] = @game.turn
  end

  def update_won_subgames
    game = board[@subgame]

    @game.won_subgames[@subgame] = @game.turn if self.class.won_subgame?(game)
  end

  def update_valid_subgames
    if @game.won_subgames[@subgame] != ''
      @game.valid_subgames = Game.initial_valid_subgames - @game.won_subgames_indexes
    else
      @game.valid_subgames = [@cell]
    end
  end

  def check_for_winner_and_update_turn
    # Check if the game is over
    if self.class.won_subgame?(@game.won_subgames)
      @game.completed = true
    else
      @game.turn = (
        @game.turn == Game::PLAYERS[0] ? Game::PLAYERS[1] : Game::PLAYERS[0]
      )
    end
  end

  def self.won_subgame?(subgame)
    # Check all three horizontal rows
    if won_subgame_set?(subgame, 0, 1, 2) then return true
    elsif won_subgame_set?(subgame, 3, 4, 5) then return true
    elsif won_subgame_set?(subgame, 6, 7, 8) then return true
    elsif won_subgame_set?(subgame, 0, 3, 6) then return true
    elsif won_subgame_set?(subgame, 1, 4, 7) then return true
    elsif won_subgame_set?(subgame, 2, 5, 8) then return true
    elsif won_subgame_set?(subgame, 0, 4, 8) then return true
    end

    false
  end

  def self.won_subgame_set?(subgame, i, j, k)
    subgame[i] != '' && subgame[i] == subgame[j] && subgame[j] == subgame[k]
  end
end
