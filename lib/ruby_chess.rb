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
                if board[row][space] == '*'
                    print " #{@board[row][space]} |"
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

class Board
   include BoardPrinting
    attr_accessor :board
    def initialize
        @board = Array.new(8, '*')
        @board.each_index {|index| @board[index] = Array.new(8, '*')}
        add_pieces
    end

    def add_pieces
        add_black_pieces
        add_white_pieces
    end

    def add_white_pieces
        @board[0][0] = Piece.new('rook', 'black', [0, 0])
        @board[0][7] = Piece.new('rook', 'black', [0, 7])
        @board[0][1] = Piece.new('knight', 'black', [0, 1])
        @board[0][6] = Piece.new('knight', 'black', [0, 6])
        @board[0][2] = Piece.new('bishop', 'black', [0, 2])
        @board[0][5] = Piece.new('bishop', 'black', [0, 5])
        @board[0][3] = Piece.new('queen', 'black', [0, 3])
        @board[0][4] = Piece.new('king', 'black', [0, 4])
        @board[1].each_index do |index|
            @board[1][index] = Piece.new('pawn', 'black', [1, index])
        end
    end

    def add_black_pieces
        @board[7][0] = Piece.new('rook', 'white', [7, 0])
        @board[7][7] = Piece.new('rook', 'white', [7, 7])
        @board[7][1] = Piece.new('knight', 'white', [7, 1])
        @board[7][6] = Piece.new('knight', 'white', [7, 6])
        @board[7][2] = Piece.new('bishop', 'white', [7, 2])
        @board[7][5] = Piece.new('bishop', 'white', [7, 5])
        @board[7][3] = Piece.new('queen', 'white', [7, 3])
        @board[7][4] = Piece.new('king', 'white', [7, 4])
        @board[6].each_index do |index|
            @board[6][index] = Piece.new('pawn', 'white', [6, index])
        end
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