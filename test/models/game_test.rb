require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'before_validation callback' do
    game = Game.new.tap(&:valid?) # trigger validation

    assert_equal Game.default_board, game.board
    assert_equal Game.initial_valid_subgames, game.valid_subgames
    assert_equal Game.default_board.first, game.won_subgames
    refute_nil game.turn
  end
end
