# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'
require 'yaml'

require_relative 'game'
require_relative 'board_printing'
require_relative 'symbol_assigner'
require_relative 'possible_moves_creator'
require_relative 'printer'
require_relative 'board'
require_relative 'piece'
require_relative 'player'
require_relative 'saveload'

game = Game.new
game.board.board[0][4] = '*'
game.board.pieces_ary.reject! { |piece| piece.type == 'king' && piece.color == 'black' }
black_king = Piece.new('king', 'black', [4, 2], game.board)
game.board.board[4][2] = black_king
game.board.pieces_ary << black_king
game.play_game
