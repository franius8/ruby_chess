# frozen_string_literal: true

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
    end
  end
end
