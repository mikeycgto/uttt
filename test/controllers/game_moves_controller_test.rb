require 'test_helper'

class GameMovesControllerTest < ActionDispatch::IntegrationTest
  test 'POST game not found' do
    post '/move', params: { id: -1 }

    assert_response :not_found
    assert_includes json_response, :message
  end
end
