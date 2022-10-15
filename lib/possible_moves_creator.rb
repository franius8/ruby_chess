# Creates the arrays of posible moves used by chess pieces
module PossibleMovesCreator
    # Array of possible moves with possible captures
    def possible_moves_with_capture
      @moves_ary = []
      possible_moves_without_capture
      possible_captures
      @moves_ary
    end
  
    # Array of possible moves without captures
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
  
    # Possible moves for pieces moving diagonally and/or vertically
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
  
    # Possible moves for pieces with their own special move arrays
    def possible_moves_for_other(allowed_moves, before_move)
      allowed_moves.each do |move|
        position_after = [0, 0]
        position_after[0] = before_move[0] + move[0]
        position_after[1] = before_move[1] + move[1]
        if move_valid?(position_after)
          @moves_ary << position_after
        end
      end
    end
  
    # Array of possible captures
    def possible_captures
      before_move = @position
      capture_ary = if @allowed_capture.nil?
                      @allowed_moves
                    else
                      @allowed_capture
                    end
      case @type
      when 'queen', 'rook', 'bishop'
        possible_captures_for_dgvert(capture_ary, before_move)
      else
        possible_captures_for_other(capture_ary, before_move)
      end
    end
  
    # Possible captures for pieces moving diagonally and/or vertically
    def possible_captures_for_dgvert(capture_ary, before_move)
      capture_ary.each do |capture|
        capture.each do |move|
          position_after = [0, 0]
          position_after[0] = before_move[0] + move[0]
          position_after[1] = before_move[1] + move[1]
          if capture_valid?(position_after)
            @moves_ary << position_after
            break
          end
        end
      end
    end
  
    # Possible captures for pieces with their own special move arrays
    def possible_captures_for_other(capture_ary, before_move)
      capture_ary.each do |move|
        position_after = [0, 0]
        position_after[0] = before_move[0] + move[0]
        position_after[1] = before_move[1] + move[1]
        if capture_valid?(position_after)
          @moves_ary << position_after
        end
      end
    end
  
    # Creation of template move arrays for all figures
    def create_move_arrays
      @all_moves = []
      create_diagonal_arrays
      create_horizontal_vertical_arrays
    end
  
    # Creation of all diagonal move arrays - each possibility separately
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
  
    # Creation of all horizontal and vertical arrays - each possibility separately
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
  
    # Constants for special move arrays
    KNIGHT_MOVES = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]].freeze
    KING_MOVES = [[1, -1], [1, 0], [1, 1], [-1, 0], [1, 0], [-1, -1], [-1, 0], [-1, 1]].freeze
    BLACK_PAWN_MOVES = [[1, 0], [2, 0]].freeze
    BLACK_PAWN_CAPTURE = [[1, 1], [1, -1]].freeze
    WHITE_PAWN_MOVES = [[-1, 0], [-2, 0]].freeze
    WHITE_PAWN_CAPTURE = [[-1, 1], [-1, -1]].freeze
    BLACK_PAWN_MOVES_AFTER_MOVE = [[1,0]].freeze
    WHITE_PAWN_MOVES_AFTER_MOVE = [[-1,0]].freeze
  end