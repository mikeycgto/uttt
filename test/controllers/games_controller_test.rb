require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test 'GET existing game' do
    game = games(:no_moves)

    get '/game', params: { id: games(:no_moves).id }, as: :json

    assert_response :success

    assert_equal game.id, json_response[:id]
    assert_equal game.board, json_response[:board]
    assert_equal game.winner, json_response[:winner]
    assert_equal game.turn, json_response[:turn]
    assert_equal game.valid_subgames, json_response[:valid_subgames]
  end

  test 'GET game not found' do
    get '/game', params: { id: -1 }, as: :json

    assert_response :not_found
    assert_includes json_response, :message
  end

  test 'POST create game' do
    assert_difference 'Game.count' do
      post '/game', as: :json
    end

    assert_response :success

    new_game = Game.last

    assert_equal new_game.id, json_response[:id]
    assert_equal Game.default_board, json_response[:board]
    assert_equal Game.initial_valid_subgames, json_response[:valid_subgames]
    assert_equal new_game.winner, json_response[:winner]
    assert_equal new_game.turn, json_response[:turn]
  end
end
