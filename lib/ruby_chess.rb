# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'

require_relative 'board_printing'
require_relative 'symbol_assigner'
require_relative 'possible_moves_creator'
require_relative 'printer'

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

# Contains the chess board with the chess pieces
class Board
  include BoardPrinting
  attr_accessor :board, :pieces_ary

  def initialize(parent)
    @parent = parent
    @board = Array.new(8, '*')
    @board.each_index { |index| @board[index] = Array.new(8, '*') }
    add_pieces
    create_pieces_array
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

  def create_pieces_array
    @pieces_ary = []
    @board.each do |row|
      row.each do |space|
        next if space == '*'
        @pieces_ary << space
      end
    end
  end
end

# Individual chess piece
class Piece
  include SymbolAssigner
  include PossibleMovesCreator
  include Printer
  attr_accessor :symbol, :color, :position, :moves_ary, :allowed_moves
  attr_reader :type

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
      @allowed_moves = KNIGHT_MOVES
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
    @allowed_capture = nil
  end
end

# Class to handle interaction with players
class Player
  include Printer

  attr_accessor :color, :check

  def initialize(color, parent)
    @color = color
    @parent = parent
    @check = false
  end

  def move_piece
    selected_position, piece = select_piece
    process_possible_moves(selected_position, piece)
    process_move(selected_position, piece)
    @check = false
    handle_check if check?(piece)
  end

  def select_piece
    selected_position = position_selector
    piece = @parent.board.board[selected_position[0]][selected_position[1]]
    [selected_position, piece]
  end

  def process_possible_moves(selected_position, piece)
    possible_moves = piece.possible_moves_with_capture
    @parent.board.print_board(selected_position, possible_moves)
    print_transformed_moves(piece)
  end

  def process_move(selected_position, piece)
    selected_move = move_selector(piece)
    @parent.board.board[selected_position[0]][selected_position[1]] = '*'
    @parent.board.board[selected_move[0]][selected_move[1]] = piece
    piece.position = selected_move
    piece.remove_excess_pawn_moves
    piece.handle_pawn_transformation
    @parent.board.print_board
  end

  def check?(piece)
    piece.possible_moves_with_capture
    piece.moves_ary.each do |move|
      @space = @parent.board.board[move[0]][move[1]]
      return true if @space.instance_of?(Piece) && @space.type == 'king' && @space.color != @color
    end
    false
  end

  def handle_check
    check_message # This needs to be finished
    @parent.determine_checked_player(self, @space)
  end
end

game = Game.new
game.board.board[4][2] = Piece.new('king', 'black', [4, 2], game.board)
game.play_game
