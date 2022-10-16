# frozen_string_literal: true

require_relative 'board_printing'

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
