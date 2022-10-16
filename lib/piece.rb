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