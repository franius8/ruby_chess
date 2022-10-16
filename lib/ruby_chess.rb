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
require_relative 'saveload'

# Controls game-level methods and victory conditions
class Game
  include Printer

  attr_accessor :board, :player, :mate, :mated_color

  def initialize
    @board = Board.new(self)
    @player1 = Player.new('white', self)
    @player2 = Player.new('black', self)
    @mate = false
    @mated_color = ''
    # play_game
  end

  def play_game
    board.print_board
    current_player = @player1
    until @mate == true
      message_before_move(current_player)
      current_player.move_piece
      current_player = switch_current_player(current_player)
    end
    mate_message(@mated_color)
  end

  def switch_current_player(current_player)
    case current_player.color
    when 'black'
      @player1
    when 'white'
      @player2
    end
  end

  def determine_checked_player(player)
    case player.color
    when 'black'
      @player1.check = true
    when 'white'
      @player2.check = true
    end
  end
end

game = Game.new
game.board.board[0][4] = '*'
game.board.pieces_ary.reject! { |piece| piece.type == 'king' && piece.color == 'black' }
black_king = Piece.new('king', 'black', [4, 2], game.board)
game.board.board[4][2] = black_king
game.board.pieces_ary << black_king
game.play_game
