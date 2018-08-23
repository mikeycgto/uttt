class Game < ApplicationRecord
  PLAYERS = %w(X O).freeze

  serialize :board, JSON
  serialize :valid_subgames, JSON
  serialize :won_subgames, JSON

  validates :board, :turn, :valid_subgames, presence: true
  validates :turn, inclusion: { in: PLAYERS }

  before_validation(on: :create) do
    self.board = self.class.default_board
    self.valid_subgames = self.class.initial_valid_subgames
    self.won_subgames = self.board.first.dup
    self.turn = PLAYERS.sample
  end

  def winner
    completed? ? turn : ''
  end

  def won_subgames_indexes
    won_subgames.map.with_index { |move, index| move == '' ? nil : index }.compact
  end

  # @return a 9x9 2-dim Array all initialized to an empty string
  def self.default_board
    Array.new(9, Array.new(9, ''))
  end

  # @return a an Array containing 0 through 8
  def self.initial_valid_subgames
    (0..8).to_a
  end
end
