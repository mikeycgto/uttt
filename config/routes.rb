Rails.application.routes.draw do
  get '/' => 'games#index'
  get 'game' => 'games#show'
  post 'game' => 'games#create'
  post 'move' => 'game_moves#create'
end
