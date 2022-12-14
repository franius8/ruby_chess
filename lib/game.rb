# frozen_string_literal: true

require_relative 'printer'

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
  end

  def play_game
    board.print_board
    @current_player = @player1 if @current_player.nil?
    until @mate == true
      message_before_move(@current_player)
      @current_player.move_piece
      @current_player = switch_current_player(@current_player)
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
