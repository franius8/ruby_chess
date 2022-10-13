require 'pry-byebug'
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
                    print "   |"
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
        @board[0][0] = Piece.new('rook', 'black', [0, 0], self)
        @board[0][7] = Piece.new('rook', 'black', [0, 7], self)
        @board[0][1] = Piece.new('knight', 'black', [0, 1], self)
        @board[0][6] = Piece.new('knight', 'black', [0, 6], self)
        @board[0][2] = Piece.new('bishop', 'black', [0, 2], self)
        @board[0][5] = Piece.new('bishop', 'black', [0, 5], self)
        @board[0][3] = Piece.new('queen', 'black', [0, 3], self)
        @board[0][4] = Piece.new('king', 'black', [0, 4], self)
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
        @board[6].each_index do |index|
            @board[6][index] = Piece.new('pawn', 'white', [6, index], self)
        end
    end
end

class Piece
    attr_accessor :symbol
    def initialize(type, color, position, parent)
        @type = type
        @position = position
        @color = color
        @parent = parent
        assign_white_symbol if color == 'white'
        assign_black_symbol if color == 'black'
        assign_allowed_moves
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

    def assign_allowed_moves
        create_move_arrays
        case @type
        when 'pawn'
            case @color
            when 'black'
                @allowed_moves = [[1,0], [2,0]]
                @allowed_capture = [[1,1], [1,-1]]
            when 'white'
                @allowed_moves = [[-1,0], [-2,0]]
                @allowed_capture = [[-1,1], [-1,-1]]
            end
        when 'knight'
            @allowed_moves = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
        when 'bishop'
            @allowed_moves = @diagonal_moves
        when 'rook'
            @allowed_moves = @horizontal_vertical_moves
        when 'king'
            @allowed_moves = @king_moves
        when 'queen'
            @allowed_moves = @diagonal_moves + @horizontal_vertical_moves
        end
    end

    def possible_moves
        before_move = @position
        @moves_ary = []
        @allowed_moves.each do |move|
            position_after = [0, 0]
            position_after[0] = before_move[0] + move[0]
            position_after[1] = before_move[1] + move[1]
            @moves_ary << position_after if move_valid?(position_after) && (@parent.board[position_after[0]][position_after[1]] == '*')
        end
        print @moves_ary
    end

    def create_move_arrays
        @diagonal_moves = []
        i = 1
        1..7.times do
            @diagonal_moves << [i,i]
            @diagonal_moves << [-i,i]
            @diagonal_moves << [i, -i]
            @diagonal_moves << [-i,-i]
            i += 1
        end
        @horizontal_vertical_moves = []
        i = 1
        1..7.times do
            @horizontal_vertical_moves << [i, 0]
            @horizontal_vertical_moves << [0, i]
            i += 1
        end
        @king_moves = [[1,-1],[1,0],[1,1],[-1,0],[1,0],[-1,-1],[-1,0],[-1,1]]
    end

    def move_valid?(position)
        position[0].between?(0, 7) && position[1].between?(0, 7)
    end
end

class Player

end

board = Board.new
board.print_board
board.board[1][0].possible_moves