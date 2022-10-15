# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'

# Handles the printing of the board
module BoardPrinting
  def print_board(position = [], moves = [])
    print_letters
    print_divider
    print_rows_with_numbers(position, moves)
    print_letters
  end

  def print_divider
    1..3.times { print ' ' }
    1..33.times { print '-' }
    print "\n"
  end

  def print_letters
    letter = 'a'
    1..5.times { print ' ' }
    1..8.times do
      print "#{letter}   "
      letter = letter.next
    end
    print "\n"
  end

  def print_rows_with_numbers(position, moves)
    number = 1
    @board.each_index do |row|
      print " #{number} |"
      @board[row].each_index do |space|
        if @board[row][space].instance_of?(String) && moves.include?([row, space])
          print '   '.colorize(color: :white, background: :light_blue)
          print '|'
        elsif board[row][space] == '*'
          print '   |'
        elsif position == @board[row][space].position
          print " #{@board[row][space].symbol} ".colorize(color: :white, background: :red)
          print '|'
        else
          print " #{@board[row][space].symbol} |"
        end
      end
      print " #{number}"
      print "\n"
      print_divider
      number += 1
    end
  end
end

# Assigns symbol to individual chess pieces
module SymbolAssigner
  def assign_white_symbol
    case @type
    when 'pawn'
      @symbol = "\u2659"
    when 'knight'
      @symbol = "\u2658"
    when 'bishop'
      @symbol = "\u2657"
    when 'rook'
      @symbol = "\u2656"
    when 'king'
      @symbol = "\u2654"
    when 'queen'
      @symbol = "\u2655"
    when 'queen'
      @symbol = "\u2654"
    end
  end

  def assign_black_symbol
    case @type
    when 'pawn'
      @symbol = "\u265F"
    when 'knight'
      @symbol = "\u265E"
    when 'bishop'
      @symbol = "\u265D"
    when 'rook'
      @symbol = "\u265C"
    when 'king'
      @symbol = "\u265A"
    when 'queen'
      @symbol = "\u265B"
    when 'queen'
      @symbol = "\u265A"
    end
  end
end

# Creates the arrays of posible moves used by chess pieces
module PossibleMovesCreator
  def possible_moves_with_capture
    @moves_ary = []
    possible_moves_without_capture
    possible_captures
    print @moves_ary
  end

  def possible_moves_without_capture
    before_move = @position
    allowed_moves = @allowed_moves
    case @type
    when 'queen', 'rook', 'bishop'
      possible_moves_for_dgvert(allowed_moves, before_move)
    else
      possible_moves_for_other(allowed_moves, before_move)
    end
  end

  def possible_moves_for_dgvert(allowed_moves, before_move)
    allowed_moves.each do |move_ary|
      move_ary.each do |move|
        position_after = [0, 0]
        position_after[0] = before_move[0] + move[0]
        position_after[1] = before_move[1] + move[1]
        if move_valid?(position_after)
          @moves_ary << position_after
        else
          break
        end
      end
    end
  end

  def possible_moves_for_other(allowed_moves, before_move)
    allowed_moves.each do |move|
      position_after = [0, 0]
      position_after[0] = before_move[0] + move[0]
      position_after[1] = before_move[1] + move[1]
      if move_valid?(position_after)
        @moves_ary << position_after
      else
        break
      end
    end
  end

  def possible_captures
    before_move = @position
    capture_ary = if @allowed_capture.nil?
                    @allowed_moves
                  else
                    [@allowed_capture]
                  end
    capture_ary.each do |capture|
      capture.each do |move|
        position_after = [0, 0]
        position_after[0] = before_move[0] + move[0]
        position_after[1] = before_move[1] + move[1]
        @moves_ary << position_after if capture_valid?(position_after)
        break
      end
    end
  end

  def create_move_arrays
    @all_moves = []
    create_diagonal_arrays
    create_horizontal_vertical_arrays
  end

  def create_diagonal_arrays
    diagonal_left_down = []
    diagonal_left_up = []
    diagonal_right_down = []
    diagonal_right_up = []
    i = 1
    1..7.times do
      diagonal_right_up << [i, i]
      diagonal_right_down << [-i, i]
      diagonal_left_up << [i, -i]
      diagonal_left_down << [-i, -i]
      i += 1
    end
    @all_moves << diagonal_left_down << diagonal_left_up << diagonal_right_down << diagonal_right_up
  end

  def create_horizontal_vertical_arrays
    horizontal_up = []
    horizontal_down = []
    vertical_up = []
    vertical_down = []
    i = 1
    1..7.times do
      horizontal_down << [i, 0]
      vertical_down << [0, i]
      vertical_up << [0, -i]
      horizontal_up << [-i, 0]
      i += 1
    end
    @all_moves << horizontal_down << horizontal_up << vertical_down << vertical_up
  end

  def move_valid?(position)
    (position[0].between?(0, 7) && position[1].between?(0, 7)) &&
      (@parent.board[position[0]][position[1]] == '*')
  end

  def capture_valid?(position)
    (position[0].between?(0, 7) && position[1].between?(0, 7)) &&
      (@parent.board[position[0]][position[1]] != '*') &&
      (@parent.board[position[0]][position[1]].color != @color)
  end

  KING_MOVES = [[1, -1], [1, 0], [1, 1], [-1, 0], [1, 0], [-1, -1], [-1, 0], [-1, 1]].freeze
  BLACK_PAWN_MOVES = [[1, 0], [2, 0]].freeze
  BLACK_PAWN_CAPTURE = [[1, 1], [1, -1]].freeze
  WHITE_PAWN_MOVES = [[-1, 0], [-2, 0]].freeze
  WHITE_PAWN_CAPTURE = [[-1, 1], [-1, -1]].freeze
  BLACK_PAWN_MOVES_AFTER_MOVE = [[1,0]].freeze
  WHITE_PAWN_MOVES_AFTER_MOVE = [[-1,0]].freeze
end

# Handles the printing of elements other than the board and getting variables
module Printer
    def position_selector
        loop do
        print "Type the position of the piece you want to move: "
        position = gets.chomp
        transformed_position = transform_position_from_user(position)
        piece = @parent.board.board[transformed_position[0]][transformed_position[1]]
        return transformed_position if position_valid?(transformed_position, piece)
        print "Invalid selection. Reason: "
        if !transformed_position[0].between?(0,7) || !transformed_position[1].between?(0,7)
            print "Position outside range."
        elsif piece == '*'
            print 'Space empty.'
        elsif piece.color != @color
            print "Space occupied by opponent's piece."
        elsif piece.possible_moves_with_capture.empty?
            print 'No possible moves.'
        else
            print 'Unspecified'
        end
        print "\n"
    end
    end

    def transform_position_from_user(position)
        transformed_position = []
        transformed_position << position.slice(1).to_i - 1
        transformed_position << position.slice(0).downcase.ord - 97
    end

    def transform_position_to_user(move)
        transformed_move = ''
        transformed_move += move[0].to_s
        transformed_move += (move[1]+97).chr
    end

    def position_valid?(transformed_position, piece)
        transformed_position[0].between?(0,7) && 
        transformed_position[1].between?(0,7) &&
        @parent.board.board[transformed_position[0]][transformed_position[1]] != '*' &&
        @parent.board.board[transformed_position[0]][transformed_position[1]].color == @color &&
        !piece.possible_moves_with_capture.empty?
    end

    def print_transformed_moves(piece)
        print "You may move to the following positions:"
        piece.possible_moves_with_capture.each do |move|
            transformed_move = transform_position_to_user(move)
            print " #{transformed_move}"
        end
        print "\n"
    end

    def move_selector(piece)
        loop do
            print 'Type the position to which you want to move: '
            move = gets.chomp
            transformed_move = transform_position_from_user(move)
            return transformed_move if piece.moves_ary.include?(transformed_move)
            print 'Invalid selection. Not a possible move.'
        end
    end

    def transformation_message
      loop do
        print "Your pawn has reached the last line. Type the piece that you want to transform it into: "
        piece = gets.chomp
        return piece if PIECES.include?(piece)
        print 'Invalid selection. Try again.'
      end
    end

    PIECES = ['rook', 'knight', 'bishop', 'queen']
end

# Controls the entire game
class Game
    attr_accessor :board, :player
    def initialize
        @board = Board.new(self)
        @player = Player.new('white', self)
    end
end

# Contains the chess board with the chess pieces
class Board
  include BoardPrinting
  attr_accessor :board

  def initialize
    @board = Array.new(8, '*')
    @board.each_index { |index| @board[index] = Array.new(8, '*') }
    add_pieces
  end

  def add_pieces
    add_black_pieces
    add_white_pieces
  end

  def add_white_pieces
    @board[0][0] = Piece.new('rook', 'black', [0, 0], self)
    @board[0][7] = Piece.new('rook', 'black', [0, 7], self)
    @board[0][1] = Piece.new('knight', 'black', [0, 1], self)
    @board[0][6] = Piece.new('knight', 'black', [0, 6], self)
    @board[0][2] = Piece.new('bishop', 'black', [0, 2], self)
    @board[0][5] = Piece.new('bishop', 'black', [0, 5], self)
    @board[0][3] = Piece.new('queen', 'black', [0, 3], self)
    @board[0][4] = Piece.new('king', 'black', [0, 4], self)
    add_white_pawns
  end

  def add_white_pawns
    @board[1].each_index do |index|
        @board[1][index] = Piece.new('pawn', 'black', [1, index], self)
      end
  end

  def add_black_pieces
    @board[7][0] = Piece.new('rook', 'white', [7, 0], self)
    @board[7][7] = Piece.new('rook', 'white', [7, 7], self)
    @board[7][1] = Piece.new('knight', 'white', [7, 1], self)
    @board[7][6] = Piece.new('knight', 'white', [7, 6], self)
    @board[7][2] = Piece.new('bishop', 'white', [7, 2], self)
    @board[7][5] = Piece.new('bishop', 'white', [7, 5], self)
    @board[7][3] = Piece.new('queen', 'white', [7, 3], self)
    @board[7][4] = Piece.new('king', 'white', [7, 4], self)
    add_black_pawns
  end

  def add_black_pawns
    @board[6].each_index do |index|
      @board[6][index] = Piece.new('pawn', 'white', [6, index], self)
    end
  end
end

# Individual chess piece
class Piece
  include SymbolAssigner
  include PossibleMovesCreator
  attr_accessor :symbol, :color, :position

  def initialize(type, color, position, parent)
    @type = type
    @position = position
    @color = color
    @parent = parent
    assign_white_symbol if color == 'white'
    assign_black_symbol if color == 'black'
    assign_allowed_moves
  end

  def assign_allowed_moves
    create_move_arrays
    case @type
    when 'pawn'
      case @color
      when 'black'
        @allowed_moves = BLACK_PAWN_MOVES
        @allowed_capture = BLACK_PAWN_MOVES
      when 'white'
        @allowed_moves = WHITE_PAWN_MOVES
        @allowed_capture = WHITE_PAWN_CAPTURE
      end
    when 'knight'
      @allowed_moves = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
    when 'bishop'
      @allowed_moves = @all_moves[0..3]
    when 'rook'
      @allowed_moves = @all_moves[4..7]
    when 'king'
      @allowed_moves = KING_MOVES
    when 'queen'
      @allowed_moves = @all_moves
    end
  end

  def remove_excess_pawn_moves
    if @type == 'pawn' && @allowed_moves.length == 2
            case @color
            when 'white'
                @allowed_moves = WHITE_PAWN_MOVES_AFTER_MOVE
            when 'black'
                @allowed_moves = BLACK_PAWN_MOVES_AFTER_MOVE
            end
        end
    end

    def handle_pawn_transformation
        if @type == 'pawn'
            if @color == 'white' && @position[0] == 0
                transform_pawn
            elsif @color == 'black' && @position[0] == 7
                transform_pawn
            end
        end
    end

    def transform_pawn
      @type = transformation_message
      assign_white_symbol if color == 'white'
      assign_black_symbol if color == 'black'
      assign_allowed_moves
    end
end

# Class to handle interaction with players
class Player
  include Printer
  
  def initialize(color, parent)
    @color = color
    @parent = parent
  end

  def select_piece
    selected_position = position_selector
    piece = @parent.board.board[selected_position[0]][selected_position[1]]
    process_possible_moves(selected_position,piece)
  end

  def process_possible_moves(selected_position,piece)
    possible_moves = piece.possible_moves_with_capture
    @parent.board.print_board(selected_position,possible_moves)
    print_transformed_moves(piece)
    process_move(selected_position, piece)
  end

  def process_move(selected_position, piece)
    selected_move = move_selector(piece)
    @parent.board.board[selected_position[0]][selected_position[1]] = '*'
    @parent.board.board[selected_move[0]][selected_move[1]] = piece
    piece.position = selected_move
    if piece.type == 'pawn'
        piece.allowed_moves.pop
    end
    @parent.board.print_board
  end

end

board = Board.new
board.print_board
board.print_board([1, 0], [[2, 0], [3, 0]])
board.board[1][0].possible_moves_with_capture
