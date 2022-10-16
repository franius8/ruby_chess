# frozen_string_literal: true

require 'pry-byebug'
require 'colorize'
require 'yaml'

require_relative 'game'
require_relative 'board_printing'
require_relative 'symbol_assigner'
require_relative 'possible_moves_creator'
require_relative 'printer'

# Used to start a new game or load existing game
class Chess

  include Printer

  def initialize
  if load_saved_game?
    game = SaveLoad.new.load
    return if game.nil?
  else
    game = Game.new
  end
  game.play_game
