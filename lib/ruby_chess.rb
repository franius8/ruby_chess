# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'

require_relative 'board_printing'
require_relative 'symbol_assigner'
require_relative 'possible_moves_creator'
require_relative 'printer'
require_relative 'board'
require_relative 'piece'
require_relative 'player'

# Controls game-level methods and victory conditions
class Game
  attr_accessor :board, :player

  def initialize
    @board = Board.new(self)
    @player1 = Player.new('white', self)
    @player2 = Player.new('black', self)
    @mate = false
    # play_game
  end

  def play_game
    board.print_board
    until @mate == true
      @player1.move_piece
      @player2.move_piece
    end
  end

  def determine_checked_player(player, piece)
    case player.color
    when 'black'
      @player1.check = true
    when 'white'
      @player2.check = true
    end
  end
end

game = Game.new
game.board.board[4][2] = Piece.new('king', 'black', [4, 2], game.board)
game.play_game
