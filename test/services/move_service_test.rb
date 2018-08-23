require 'test_helper'

class MoveServiceTest < ActiveSupport::TestCase
  test 'make_move! with new game' do
    game = games(:no_moves)
    current_turn = game.turn

    MoveService.new(game, 3, 8).make_move!

    refute_equal current_turn, game.turn
    assert_equal current_turn, game.board[3][8]
    assert_equal [8], game.valid_subgames
    assert_equal Array.new(9, ''), game.won_subgames
  end

  test 'make_move! with subgame win' do
  end

  test '::won_subgame? with a winning games' do
    subgame = ['O', 'X', 'O', 'O', 'X', 'O', 'X', 'X', '']

    assert MoveService.won_subgame?(subgame)

    subgame = ['O', '', '', 'X', 'O', '', '', 'X', 'O']

    assert MoveService.won_subgame?(subgame)
  end

  test '::won_subgame? without a winning game' do
    subgame = Game.default_board.first

    refute MoveService.won_subgame?(subgame)
  end
end
