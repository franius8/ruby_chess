require 'colorize'

module BoardPrinting
    def print_board
        print_letters
        print_divider
        print_rows_with_numbers
        print_letters
    end

    def print_divider
        1..3.times {print ' '}
        1..33.times {print '-'}
        print "\n"
    end

    def print_letters
        letter = 'a'
        1..5.times {print " "}
        1..8.times do
            print "#{letter}   "
            letter = letter.next
        end
        print "\n"
    end

    def print_rows_with_numbers
        number = 1
        @board.each_index do |row|
            print " #{number} |"
            @board[row].each_index do |space|
                print " #{@board[row][space]} |"
            end
            print " #{number}"
            print "\n"
            print_divider
            number += 1
        end
    end
end

class Board
   include BoardPrinting
    attr_accessor :board
    def initialize
        @board = Array.new(8, '*')
        @board.each_index {|index| @board[index] = Array.new(8, '*')}
    end
end

class Piece
    attr_accessor :symbol
    def initialize(type, color, position)
        @type = type
        @position = position
        assign_white_symbol if color == 'white'
        assign_black_symbol if color == 'black'
    end

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
            @symbol = "\u265B"
        when 'queen'
            @symbol = "\u265A"
        end
    end
end

board = Board.new
board.print_board
piece = Piece.new('pawn', 'black', [0,1])
puts piece.symbol.encode('utf-8')